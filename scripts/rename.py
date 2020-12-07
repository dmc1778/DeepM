import pandas as pd
import csv
import re


def read_source_file(source_path):
    with open(source_path, 'r') as file:
        data = file.readlines()
    return data


def read_csv(csv_file_path):
    return pd.read_csv(csv_file_path, sep='\t', encoding='utf-8', error_bad_lines=False)


def main():
    node_addr = '/home/nimashiri/vsprojects/DeepM/cpg_methods/findutils/do_exec.c.c/nodes.csv'
    code_addr = '/home/nimashiri/vsprojects/DeepM/sliced_methods/findutils/0do_exec.c.c'
    node = read_csv(node_addr)
    code = read_source_file(code_addr)
    all_vars = node[node['type'] == 'Identifier']
    all_callee = node[node['type'] == 'Callee']
    all_misc = node[node['type'] == 'Symbol']
    arguments = node[(node['type'] == 'Argument') and
                     (node['type'] == 'ArgumentList')]

    transformed_code = []
    seri_ = [all_vars, all_callee, all_misc, arguments]
    for line in code:
        line = re.sub(r'"(.*?(\s)*?)*?"', '', line)
        line = re.sub(r'(\(+(\.\(+)?)', r'( ', line)
        line = re.sub(r'(\)+(\.\)+)?)', r' )', line)
        line = line.replace('\n', '')
        # line = add_space(line)
        split_line = line.split(' ')
        for i, token in enumerate(split_line):
            chars = [',', ';', '.']
            rules = [token == 'kfree',
                     token == 'kzalloc',
                     token == 'free',
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
            if not any(rules):
                for flag, s in enumerate(seri_):
                    if flag == 0:
                        for j, v in enumerate(s['code']):
                            if v not in var_names:
                                var_names[v] = 'var'+str(j)
                        selected = var_names
                    elif flag == 1:
                        for j, v in enumerate(s['code']):
                            if v not in func_names:
                                func_names[v] = 'method'+str(j)
                        selected = func_names
                    elif flag == 2:
                        for j, v in enumerate(s['code']):
                            if v not in misc_names:
                                misc_names[v] = 'method'+str(j)
                        selected = misc_names
                    else:
                        for j, v in enumerate(s['code']):
                            if v not in arg_names:
                                arg_names[v] = 'arg'+str(j)
                        selected = arg_names
                    for key, value in selected.items():
                        if key != 'NULL':
                            if not isinstance(v, float):
                                for item in chars:
                                    token = token.replace(item, '')
                                if '*' in token or '&' in token:
                                    v = v.replace(' ', '')
                                if key == token:
                                    split_line[i] = value
                                    # if flag == 0:
                                    #     split_line[i] = value
                                    # elif flag == 1:
                                    #     split_line[i] = value
                                    # elif flag == 2:
                                    #     split_line[i] = value
                                    # else:
                                    #     split_line[i] = value
                                else:
                                    pass
        line = ' '.join(split_line)
        final_rules = [
            'return' in line,
            '}' in line
        ]
        if not any(final_rules):
            transformed_code.append(line)
    print(transformed_code)


if __name__ == "__main__":
    main()
