import os
import fnmatch
import pandas as pd
from nltk.tokenize import word_tokenize
import csv
import string
from gensim.models import Word2Vec
import shutil


combined_path = './combined_projects_file'
out_path = "./datasets"
abstraction_clean_path = './abstraction_clean'
abstraction_buggy_path = './abstraction_buggy'


class ProcessMethods:
    def __init__(self) -> None:
        self.UMA = False
        self.FMA = False
        self.FHM = False

    def exec(self):
        self.list_all_files()
        self.CustomeTokenizer()

    def w2v(self, df):
        methodTitles = df['method'].values
        new_df = [word_tokenize(_method) for _method in methodTitles]
        model = Word2Vec(new_df, min_count=1, size=32)
        print(len(model.wv.syn0))
        return self

    def write_file(self, project_name, ver, _file):
        _path = os.path.join(out_path, project_name)
        if not os.path.exists(_path):
            os.makedirs(_path)
        _file.to_csv(_path + '/' + ver + '.csv',
                     encoding='utf-8', index=False)
        return self

    def load_file(self, file_addr):
        return open(file_addr, 'r').read().replace('\n', '')

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

    def CustomeTokenizer(self, _dir):
        raw_txt = self.load_file(_dir)
        return word_tokenize(raw_txt)

    def combine_project_files(self):
        for root, project_dir, _ in os.walk(abstraction_clean_path):
            for project_ in project_dir:
                _cwd = os.path.join(root, project_)
                for _, release, _ in os.walk(_cwd):
                    for _ver in release:
                        clean_code_i = os.path.join(
                            root, project_, _ver)

                        buggy_code_i = os.path.join(
                            abstraction_buggy_path, project_, _ver)

                        new_path_clean = os.path.join(
                            combined_path, project_, _ver, 'clean')
                        new_path_buggy = os.path.join(
                            combined_path, project_, _ver, 'buggy')

                        if not os.path.exists(new_path_buggy):
                            os.makedirs(new_path_buggy)
                        if not os.path.exists(new_path_clean):
                            os.makedirs(new_path_clean)

                        for _file in os.listdir(clean_code_i):
                            print('coppying clean files', _file)
                            shutil.copyfile(clean_code_i+'/'+_file,
                                            new_path_clean+'/'+_file)
                        for _file in os.listdir(buggy_code_i):
                            print('coppying buggy files', _file)
                            shutil.copyfile(buggy_code_i+'/'+_file,
                                            new_path_buggy+'/'+_file)
        return self

    def list_all_files(self):
        for root, project_dir, _ in os.walk(combined_path):
            for project_ in project_dir:
                _cwd = os.path.join(root, project_)
                versions = os.listdir(_cwd)
                for _ver in versions:
                    temp = []
                    current_ver = os.path.join(_cwd, _ver)
                    clean_buggy = os.listdir(current_ver)
                    for status in clean_buggy:
                        _method_list = os.path.join(current_ver, status)
                        _methd_list = os.listdir(_method_list)
                        for _file in os.listdir(_method_list):
                            print(_file)
                            file_to_load = os.path.join(
                                current_ver, status, _file)
                            myfile = self.read_code_file(file_to_load)
                            if status == 'buggy':
                                label_indicator = 1
                            else:
                                label_indicator = 0
                            x = []
                            for _, key in myfile.items():
                                x.append(key)
                            result = ' '.join(x)
                            temp.append(
                                [_file, str(result), int(label_indicator)])
                            df_i = pd.DataFrame(
                                temp, columns=('method_name', 'method', 'status'))
                            result = []
                    self.write_file(project_, _ver, df_i)
                    # self.w2v(df_i)
                    df_i = pd.DataFrame(None)
                    temp = []


if __name__ == '__main__':
    _pm = ProcessMethods()
    # _pm.combine_project_files()
    _pm.exec()
