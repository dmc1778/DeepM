import pandas as pd
import csv
import re
import os
import string
import numpy as np

sliced_methods_path = './mutated_methods'
transformed_methods_path = './abstraction_buggy'
CPG_methods_path = './cpg_methods'


# def apply_mutations():
#     start = mystring.find('(')
#     end = mystring.find(')')
#     if start != -1 and end != -1:
#     result = mystring[start+1:end]

#     '(malloc|xmalloc|kmalloc*\s*) \(((.*))\)'


def write_file(project_name, _file, _file_name, _ver):
    _path = os.path.join(transformed_methods_path, project_name, _ver)
    if not os.path.exists(_path):
        os.makedirs(_path)
    ready_to_go = os.path.join(_path, _file_name)
    fp = open(ready_to_go, 'w')
    for line in _file:
        fp.writelines(line + '\n')
    fp.close()
    pass


def read_source_file(source_path):
    with open(source_path, 'r') as file:
        data = file.readlines()
    return data


def read_csv(csv_file_path):
    return pd.read_csv(csv_file_path, sep='\t', encoding='utf-8', error_bad_lines=False)


def main():
    for root, project_dir, _ in os.walk(CPG_methods_path):
        for _dir in project_dir:
            cwd = os.path.join(root, _dir)
            for _, release, _ in os.walk(cwd):
                for _ver in release:
                    current_working_dir = os.path.join(root, _dir, _ver)
                    for sub_root, sub_dir, sub_file in os.walk(current_working_dir):
                        for _code_i in sub_dir:
                            code_dir = os.path.join(
                                sliced_methods_path, _dir, _ver)
                            node_dir = os.path.join(
                                sub_root, _code_i, sub_file[1])
                            node = read_csv(node_dir)
                            for source_root, _, cwd_source in os.walk(code_dir):
                                for code_snippet in cwd_source:
                                    # compare _file and code_snippet
                                    new_code_snippet = code_snippet[1:]
                                    if _code_i == new_code_snippet:
                                        code_to_load_path = os.path.join(
                                            code_dir, code_snippet)
                                        code = read_source_file(
                                            code_to_load_path)

                                        all_vars = node[node['type']
                                                        == 'Identifier']
                                        all_callee = node[node['type']
                                                          == 'Callee']
                                        all_misc = node[node['type']
                                                        == 'Symbol']
                                        arguments = node[node['type'].isin(
                                            ['Argument', 'ArgumentList'])]
                                        parameter_types = node[node['type']
                                                               == 'ParameterType']

                                        transformed_code = []
                                        seri_ = [all_vars, all_callee,
                                                 all_misc, arguments, parameter_types]
                                        print(_code_i)
                                        for line in code:
                                            line = re.sub(
                                                r'"(.*?(\s)*?)*?"', '', line)
                                            line = re.sub(
                                                r'(\(+(\.\(+)?)', r'( ', line)
                                            line = re.sub(r'(\)+(\.\)+)?)',
                                                          r' )', line)
                                            line = line.replace('\n', '')
                                            # line = add_space(line)
                                            split_line = line.split(' ')
                                            for i, token in enumerate(split_line):
                                                chars = [',', ';', '.']
                                                rules = [token == 'kfree',
                                                         token == 're_free',
                                                         token == 'free_buffer',
                                                         token == 'vfree',
                                                         token == 'free',
                                                         token == 'pfree',
                                                         token == 'kzalloc',
                                                         token == 'realloc',
                                                         token == 'malloc',
                                                         token == 'vmalloc',
                                                         token == 'kmalloc',
                                                         token == 'xmalloc',
                                                         token == 'calloc',
                                                         token == 'kcalloc']

                                                var_names = {}
                                                func_names = {}
                                                misc_names = {}
                                                arg_names = {}
                                                param_types = {}
                                                if not any(rules):
                                                    for flag, s in enumerate(seri_):
                                                        if flag == 0:
                                                            for j, v in enumerate(s['code']):
                                                                if not pd.isnull(v):
                                                                    if v not in var_names:
                                                                        var_names[v] = 'var' + \
                                                                            str(j)
                                                            selected = var_names
                                                        elif flag == 1:
                                                            for j, v in enumerate(s['code']):
                                                                if not pd.isnull(v):
                                                                    if v not in func_names:
                                                                        func_names[v] = 'method' + \
                                                                            str(j)
                                                            selected = func_names
                                                        elif flag == 2:
                                                            for j, v in enumerate(s['code']):
                                                                if not pd.isnull(v):
                                                                    if v not in misc_names:
                                                                        misc_names[v] = 'symbol' + \
                                                                            str(j)
                                                            selected = misc_names
                                                        elif flag == 3:
                                                            for j, v in enumerate(s['code']):
                                                                if not pd.isnull(v):
                                                                    if _code_i == 'process_path.c.c':
                                                                        print(
                                                                            'ok')
                                                                    v = re.sub(
                                                                        r'[\s+]', "", v)
                                                                    if v not in arg_names:
                                                                        arg_names[v] = 'arg' + \
                                                                            str(j)
                                                            selected = arg_names
                                                        else:
                                                            for j, v in enumerate(s['code']):
                                                                if v not in param_types:
                                                                    if v != None:
                                                                        param_types[v] = 'paramType' + \
                                                                            str(j)
                                                            selected = param_types
                                                        for key, value in selected.items():
                                                            if key != 'NULL':
                                                                if not isinstance(v, float):
                                                                    for item in chars:
                                                                        token = token.replace(
                                                                            item, '')
                                                                    if '*' in token or '&' in token:
                                                                        v = v.replace(
                                                                            ' ', '')
                                                                    if key == token:
                                                                        split_line[i] = value
                                                                    else:
                                                                        pass
                                            line = ' '.join(split_line)
                                            final_rules = [
                                                'return' in line,
                                                '}' in line
                                            ]
                                            if not any(final_rules):
                                                transformed_code.append(
                                                    line)
                                        write_file(
                                            _dir, transformed_code, code_snippet, _ver)
                                    else:
                                        pass


if __name__ == "__main__":
    main()
