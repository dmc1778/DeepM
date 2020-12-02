import os
from pickle import TRUE
import re
import json
import codecs
import nltk
from nltk.tokenize import word_tokenize

label_flag = 3
project_name = "xorg"

Path = "E:\\apply\\york\\Courses\\EECS 6444\\final project\\source\\all_methods\\"+project_name+"\\"
PotentialPath = "E:\\apply\\york\\Courses\\EECS 6444\\final project\\source\\potential_methods\\" + \
    project_name+"\\method\\"+str(label_flag)
PotentialPathLabel = "E:\\apply\\york\\Courses\\EECS 6444\\final project\\source\\potential_methods\\" + \
    project_name+"\\labels\\"+str(label_flag)


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

    def reset_flag(self):
        self.UMA = False
        self.FMA = False
        self.FHM = False

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
        local_memalloc_flag = False
        local_null_flag = False
        if "calloc (" in self._method:
            self.calloc_counter += 1
            local_memalloc_flag = True
        if "kcalloc (" in self._method:
            self.kcalloc_counter += 1
            local_memalloc_flag = True
        if "xcalloc (" in self._method:
            self.xcalloc_counter += 1
            local_memalloc_flag = True

        #   (^[^\s]*)([$^!|==])*\s*=\s*(NULL)(.*)
        for line in self._method:
            regex = r'(^[^\s]*)([$^!|==])*\s*=\s*(NULL)(.*)'
            _x = re.findall(regex, line, re.MULTILINE)
            global_pass_counter = 0
            line_tokenized = word_tokenize(line)
            null_flag = line_tokenized.__contains__('NULL')
            if null_flag:
                for i, v in enumerate(line_tokenized):
                    if v == 'if' or v == 'while' or v == 'for' or v == 'return':
                        break
                    if v != '=':
                        global_pass_counter += 1
                    if global_pass_counter > 1:
                        break
                    else:
                        local_null_flag = True
                        self.null_counter += 1
        if local_memalloc_flag == True or local_null_flag == True:
            self.UMA = True

    def func_FMA(self):
        for line in self._method:
            pattern1 = re.findall(
                r'(malloc|xmalloc|kmalloc)\s*\(\s*(^0|-*[0-9]+[0-9]*\s*\*)\s*sizeof\s*\(.*\)\s*\)', line)
            pattern2 = re.findall(
                r'(malloc|xmalloc|kmalloc)\s*\(\s*sizeof\s*\(.*\)\s*\)', line)
            pattern3 = re.findall(
                r'(malloc|xmalloc|kmalloc*\s*) \((sizeof\s*(.*))\)', line)
            if "calloc (" in line:
                self.calloc_counter += 1
                self.FMA = True
            if "kcalloc (" in line:
                self.kcalloc_counter += 1
                self.FMA = True
            if "xcalloc (" in line:
                self.xcalloc_counter += 1
                self.FMA = True
            if "malloc (" in line:
                self.malloc_counter += 1
                self.FMA = True
            if "kmalloc (" in line:
                self.kmalloc_counter += 1
                self.FMA = True
            if "xmalloc (" in line:
                self.xmalloc_counter += 1
                self.FMA = True

            if len(pattern1) != 0:
                self.FMA = True
                self.sizeOf_counter += 1
            if len(pattern2) != 0:
                self.FMA = True
                self.sizeOf_counter += 1
            if len(pattern3) != 0:
                self.FMA = True
                self.sizeOf_counter += 1

    def func_FHM(self):
        for line in self._method:
            # group = re.findall(r'\b((free|kfree)*\s*)\((.*)\)', line)
            if 'free (' in line:
                self.FHM = True
                self.free_counter += 1
            if 'kfree (' in line:
                self.FHM = True
                self.free_counter += 1
            if "calloc (" in line:
                self.calloc_counter += 1
                self.FHM = True
            if "kcalloc (" in line:
                self.kcalloc_counter += 1
                self.FHM = True
            if "xcalloc (" in line:
                self.xcalloc_counter += 1
                self.FHM = True
            if "malloc (" in line:
                self.malloc_counter += 1
                self.FHM = True
            if "kmalloc (" in line:
                self.kmalloc_counter += 1
                self.FHM = True
            if "xmalloc (" in line:
                self.xmalloc_counter += 1
                self.FHM = True

    def apply(self):
        if label_flag == 1:
            self.func_UMA()
        elif label_flag == 2:
            self.func_FMA()
        else:
            self.func_FHM()

    def buildWrite(self, methodName):
        if label_flag == 1:
            c = {"UMA": self.UMA}
            allow_write = c['UMA']
        elif label_flag == 2:
            c = {"FMA": self.FMA}
            allow_write = c['FMA']
        else:
            c = {"FHM": self.FHM}
            allow_write = c['FHM']
        #c = {"FHM": self.FHM }
        # c = {"UMA": self.UMA, "FMA": self.FMA, "FHM": self.FHM }
        # self.pair['method'] = self._method
        # self.pair['fault'] = c

        if allow_write != False:
            with codecs.open(PotentialPathLabel + "/%s.json" % (methodName), 'w', encoding='utf-8') as f_label:
                json.dump(c, f_label, ensure_ascii=False, indent=4)
            with codecs.open(PotentialPath + "/%s.c" % (methodName), 'w', encoding='utf-8') as f_method:
                for line in self._method:
                    f_method.writelines(line)


def main():
    _obj = CheckPotential()
    filelist = os.listdir(Path)
    i = 0
    for x in filelist:
        if x.endswith(".c"):
            with codecs.open(Path + x, "r", encoding="ascii") as f:
                data_dict = f.readlines()
                _obj.set(data_dict)
                _obj.apply()
                _obj.buildWrite(x)
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
