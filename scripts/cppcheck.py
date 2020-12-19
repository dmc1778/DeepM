import os
import sys
import argparse
from graphviz import Digraph
import csv
import random
from sklearn.metrics import classification_report, confusion_matrix
import numpy as np
from nltk.tokenize import word_tokenize, WhitespaceTokenizer
import itertools
import re
from sklearn import metrics


def null_identifier(line):
    line_tokenized = WhitespaceTokenizer().tokenize(line)
    combs = list(itertools.combinations(line_tokenized, 2))
    for item in combs:
        if item[0] == '=' and item[1] == 'NULL':
            return True


def read_csv(csv_file_path):
    data = []
    with open(csv_file_path, encoding='utf-8') as fp:
        header = fp.readline()
        header = header.strip()
        h_parts = [hp.strip() for hp in header.split('\t')]
        for line in fp:
            line = line.strip()
            instance = {}
            lparts = line.split('\t')
            for i, hp in enumerate(h_parts):
                if i < len(lparts):
                    content = lparts[i].strip()
                else:
                    content = ''
                instance[hp] = content
            data.append(instance)
        return data


def read_criteria_file(file_path):
    # file_path = file_path.replace('.c.c.csv', '.c.csv')
    # file_path = file_path.replace('.c.c.csv', '.c.csv')
    with open(file_path, 'r') as fp:
        csvreader = csv.reader(fp)
        rows = []
        for row in csvreader:
            rows.append(row)
    return rows


def read_code_file(file_path):
    code_lines = {}
    with open(file_path) as fp:
        for ln, line in enumerate(fp):
            assert isinstance(line, str)
            line = line.strip()
            if '//' in line:
                line = line[:line.index('//')]
            code_lines[ln + 1] = line
        return code_lines


if __name__ == '__main__':
    cppcheck_of_methods_path = './cppcheck_results'
    codes_paths = './mutated_methods'
    codes_criteria_path = './potential_methods'
    for root, dirname, _ in os.walk(codes_criteria_path):
        for sub_dir in dirname:
            _cwd = os.path.join(codes_paths, sub_dir)
            for _, versions, _ in os.walk(_cwd):
                TP = 0
                FP = 0
                TN = 0
                pred_y = []
                for _ver in versions:
                    print("I am working on: % s" % (_ver))
                    path_to_cpp_res = os.path.join(
                        cppcheck_of_methods_path, _ver+'.txt')
                    path_to_mutation = os.path.join(_cwd, _ver)
                    # path_to_potential = os.path.join(root, sub_dir, _ver)

                    path_criteria_file = os.path.join(root,
                                                      sub_dir, _ver, 'meta')

                    viprime = read_code_file(path_to_cpp_res)
                    for _, _, list_of_files in os.walk(path_to_mutation):
                        counter = 0
                        for _file in list_of_files:
                            # counter += 1
                            # print("The number of files processed: % d" %
                            #       (counter))
                            path_ = os.path.join(
                                path_criteria_file, _file[1:]+'.csv')

                            path_ = path_.replace('.c.c.csv', '.c.csv')
                            if os.path.isfile(path_):
                                criteria_file = read_criteria_file(path_)
                                code = os.path.join(
                                    codes_paths, sub_dir, _ver, _file)
                                code = read_code_file(code)

                                myflag = False
                                for k, v in code.items():
                                    for key, value in viprime.items():
                                        if _file in value:
                                            if 'assigned value is 0' in value:
                                                myflag = True
                            if myflag:
                                pred_y.append(1)
                            else:
                                pred_y.append(0)
                    actual = [1 for i in range(len(pred_y))]
                    report = classification_report(
                        actual, pred_y, output_dict=True)
                    print("results for: %s" % (_ver))
                    print("Precision: %5.2f" %
                          (round(report['weighted avg']['precision'], 2)))
                    print("Recall: %5.2f" % round(report['1']['recall'], 2))
                    print("F1 score: %5.2f" %
                          round(report['1']['f1-score'], 2))
                    CM = confusion_matrix(actual, pred_y)
                    TN = CM[0][0]
                    FN = CM[1][0]
                    TP = CM[1][1]
                    FP = CM[0][1]

                    Precision = TP / (TP + FP)
                    fpr, tpr, thresholds = metrics.roc_curve(
                        actual, pred_y, pos_label=1)
                    print(metrics.auc(fpr, tpr))
