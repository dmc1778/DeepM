import os
from pickle import TRUE
import re
import json
import codecs
import nltk
from nltk.tokenize import word_tokenize, WhitespaceTokenizer
import os
from pathlib import Path
import itertools
import csv
from sklearn import metrics

label_flag = 3
project_name = "coreutils"

base_path = "./all_new"

PotentialPath = "./potential_methods/"


class CheckPotential:
    def __init__(self) -> None:
        self._method = ""
        self.malloc_counter = 0
        self.kmalloc_counter = 0
        self.xmalloc_counter = 0
        self.calloc_counter = 0
        self.kcalloc_counter = 0
        self.xcalloc_counter = 0

        self.free_counter = 0
        self.kfree_counter = 0
        self.null_counter = 0
        self.sizeOf_counter = 0

        self.UMA = False
        self.FMA = False
        self.FHM = False
        self.line_reg = []

    def reset_flag(self):
        self.UMA = False
        self.FMA = False
        self.FHM = False
        self.line_reg = []

    def get(self):
        return self._method

    def set(self, _input):
        self._method = _input
        # x = {
        #     "method": "",
        #     "fault": "",
        # }
        # self.pair = x

    def func_UMA(self):
        if len(self._method) > 3:
            for line in self._method:
                if line != 1:
                    # line = line.replace('\n', '')
                    # line = line.replace('\r', '')
                    if "calloc (" in self._method[line]:
                        self.calloc_counter += 1
                        self.line_reg.append(line)
                    if "kcalloc (" in self._method[line]:
                        self.kcalloc_counter += 1
                        self.line_reg.append(line)
                    if "xcalloc (" in self._method[line]:
                        self.xcalloc_counter += 1
                        self.line_reg.append(line)

                    line_tokenized = WhitespaceTokenizer().tokenize(
                        self._method[line])
                    combs = list(itertools.combinations(line_tokenized, 2))
                    for item in combs:
                        if item[0] == '=' and item[1] == 'NULL':
                            self.line_reg.append(line)

                    pattern1 = re.findall(
                        r'(malloc|xmalloc|kmalloc)\s*\(\s*(^0|-*[0-9]+[0-9]*\s*\*)\s*sizeof\s*\(.*\)\s*\)', self._method[line])
                    pattern2 = re.findall(
                        r'(malloc|xmalloc|kmalloc)\s*\(\s*sizeof\s*\(.*\)\s*\)', self._method[line])
                    pattern3 = re.findall(
                        r'(malloc|xmalloc|kmalloc*\s*) \((sizeof\s*(.*))\)', self._method[line])
                    if re.search(r'\bcalloc \(\b', self._method[line]):
                        self.calloc_counter += 1
                        self.FMA = True
                        self.line_reg.append(line)
                    if re.search(r'\bkcalloc \(\b', self._method[line]):
                        self.kcalloc_counter += 1
                        self.FMA = True
                        self.line_reg.append(line)
                    if re.search(r'\bxcalloc \(\b', self._method[line]):
                        self.xcalloc_counter += 1
                        self.FMA = True
                        self.line_reg.append(line)
                    if re.search(r'\bmalloc \(\b', self._method[line]):
                        self.malloc_counter += 1
                        self.FMA = True
                        self.line_reg.append(line)
                    if re.search(r'\bkmalloc \(\b', self._method[line]):
                        self.kmalloc_counter += 1
                        self.FMA = True
                        self.line_reg.append(line)
                    if re.search(r'\bxmalloc \(\b', self._method[line]):
                        self.xmalloc_counter += 1
                        self.FMA = True
                        self.line_reg.append(line)

                    # if len(pattern1) != 0:
                    #     self.FMA = True
                    #     self.sizeOf_counter += 1
                    #     self.line_reg.append(line)
                    # if len(pattern2) != 0:
                    #     self.FMA = True
                    #     self.sizeOf_counter += 1
                    #     self.line_reg.append(line)
                    # if len(pattern3) != 0:
                    #     self.FMA = True
                    #     self.sizeOf_counter += 1
                    #     self.line_reg.append(line)

                    # group = re.findall(r'\b((free|kfree)*\s*)\((.*)\)', line)
                    if 'free (' in self._method[line]:
                        self.FHM = True
                        self.free_counter += 1
                        self.line_reg.append(line)
                    if 'kfree (' in self._method[line]:
                        self.FHM = True
                        self.free_counter += 1
                        self.line_reg.append(line)

    def apply(self):
        self.func_UMA()

    def buildWrite(self, sub_dir, sub_sub_dir, methodName):
        if len(self.line_reg) > 0:
            _cwd_method = os.path.join(
                PotentialPath, sub_dir, sub_sub_dir, 'methods')
            _cwd_meta = os.path.join(
                PotentialPath, sub_dir, sub_sub_dir, 'meta')
            if not os.path.exists(_cwd_method):
                os.makedirs(_cwd_method)
            if not os.path.exists(_cwd_meta):
                os.makedirs(_cwd_meta)
            with codecs.open(_cwd_method + "/%s.c" % (methodName), 'w', encoding='utf-8') as f_method:
                for line in self._method:
                    f_method.write("%s\n" % self._method[line])
                f_method.close()
            with open(_cwd_meta + "/%s.csv" % (methodName), 'w') as f_meta:
                x = list(set(self.line_reg))
                writer = csv.writer(f_meta, delimiter=',')
                writer.writerow(x)

    def read_code_file(self, file_path):
        code_lines = {}
        with open(file_path) as fp:
            for ln, line in enumerate(fp):
                assert isinstance(line, str)
                line = line.strip()
                if '//' in line:
                    line = line[:line.index('//')]
                code_lines[ln + 1] = line
        return code_lines


def main():
    _obj = CheckPotential()
    # filelist = os.listdir(Path)
    i = 0
    for root, dirnames, _ in os.walk(base_path):
        for sub_dir in dirnames:
            cwd = os.path.join(root, sub_dir)
            filelist = sorted(os.listdir(cwd))
            for item in filelist:
                sub_cwd = os.path.join(cwd, item)
                if os.path.isdir(sub_cwd):
                    sub_item = sorted(os.listdir(sub_cwd))
                    for x in sub_item:
                        if x.endswith(".c"):
                            full_path = os.path.join(sub_cwd, x)
                            data_dict = _obj.read_code_file(full_path)
                            # with codecs.open(full_path, "r", encoding="ascii") as f:
                            #data_dict = f.readlines()
                            _obj.set(data_dict)
                            _obj.apply()
                            _obj.buildWrite(sub_dir, item, x)
                            _obj.reset_flag()
                        print("DYNAMIC MEMORY ALLOCATION")
                        print("malloc:", _obj.malloc_counter)
                        print("kmalloc:", _obj.kmalloc_counter)
                        print("xmalloc:", _obj.xmalloc_counter)
                        print("calloc:", _obj.calloc_counter)
                        print("kcalloc:", _obj.kcalloc_counter)
                        print("xcalloc:", _obj.xcalloc_counter)
                        print("OTHER")
                        print("NULL:", _obj.null_counter)
                        print("sizeOf:", _obj.sizeOf_counter)
                        print("free:", _obj.free_counter)
                        print("kfree:", _obj.kfree_counter)
                        i += 1
                        print(i)


if __name__ == '__main__':
    main()
