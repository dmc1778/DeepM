import os
import fnmatch
import pandas as pd
from nltk.tokenize import word_tokenize
import csv
import string
from gensim.models import Word2Vec
import shutil

base_path = ["./sliced_methods", "./mutated_methods"]

out_path = "./datasets"


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

    def write_file(self, project_name, _file):
        _path = os.path.join(out_path)
        if not os.path.exists(_path):
            os.makedirs(_path)
        _file.to_csv(_path+'/'+project_name + '.csv',
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
        combined_path = './combined_projects_file'
        sliced_methods_path = './sliced_methods'
        mutated_methods_path = './mutated_methods'

        for _, project_dir, _ in os.walk(sliced_methods_path):
            for project_ in project_dir:
                new_path_clean = os.path.join(combined_path, project_, 'clean')
                new_path_buggy = os.path.join(combined_path, project_, 'buggy')
                if not os.path.exists(new_path_buggy):
                    os.makedirs(new_path_buggy)
                if not os.path.exists(new_path_clean):
                    os.makedirs(new_path_clean)

                sliced_methods_f = os.path.join(sliced_methods_path, project_)
                mutated_methods_f = os.path.join(
                    mutated_methods_path, project_)
                for _file in os.listdir(sliced_methods_f):
                    shutil.copyfile(sliced_methods_f+'/'+_file,
                                    new_path_clean+'/'+_file)
                for _file in os.listdir(mutated_methods_f):
                    shutil.copyfile(mutated_methods_f+'/'+_file,
                                    new_path_buggy+'/'+_file)
        return self

    def list_all_files(self):
        combined_path = './combined_projects_file'
        for root, project_dir, _ in os.walk(combined_path):
            for project_ in project_dir:
                temp = []
                subdir = os.path.join(root, project_)
                listDir = os.listdir(subdir)
                for label_dir in listDir:
                    cwd = os.path.join(subdir, label_dir)
                    for _method in os.listdir(cwd):
                        working_dir = os.path.join(cwd, _method)
                        myfile = self.read_code_file(working_dir)
                        if label_dir == 'buggy':
                            label_indicator = 1
                        else:
                            label_indicator = 0
                        temp.append((myfile, label_indicator))
                        df_i = pd.DataFrame(temp, columns=('method', 'status'))
                self.write_file(project_, df_i)
                # self.w2v(df_i)
                df_i = pd.DataFrame(None)
                temp = []


if __name__ == '__main__':
    _pm = ProcessMethods()
    _pm.combine_project_files()
    _pm.exec()
