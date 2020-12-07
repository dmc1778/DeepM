import os
import sys
import argparse
from graphviz import Digraph
import csv
import random


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
    file_path = file_path.replace('.c.c', '.c.csv')
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


def extract_nodes_with_location_info(nodes):
    # Will return an array identifying the indices of those nodes in nodes array,
    # another array identifying the node_id of those nodes
    # another array indicating the line numbers
    # all 3 return arrays should have same length indicating 1-to-1 matching.
    node_indices = []
    node_ids = []
    line_numbers = []
    node_id_to_line_number = {}
    for node_index, node in enumerate(nodes):
        assert isinstance(node, dict)
        if 'location' in node.keys():
            location = node['location']
            if location == '':
                continue
            line_num = int(location.split(':')[0])
            node_id = node['key'].strip()
            node_indices.append(node_index)
            node_ids.append(node_id)
            line_numbers.append(line_num)
            node_id_to_line_number[node_id] = line_num
    return node_indices, node_ids, line_numbers, node_id_to_line_number


def create_adjacency_list(line_numbers, node_id_to_line_numbers, edges, data_dependency_only=True):
    adjacency_list = {}
    for ln in set(line_numbers):
        adjacency_list[ln] = [set(), set()]
    for edge in edges:
        edge_type = edge['type'].strip()
        if True:  # edge_type in ['IS_AST_PARENT', 'FLOWS_TO']:
            start_node_id = edge['start'].strip()
            end_node_id = edge['end'].strip()
            if start_node_id not in node_id_to_line_numbers.keys() or end_node_id not in node_id_to_line_numbers.keys():
                continue
            start_ln = node_id_to_line_numbers[start_node_id]
            end_ln = node_id_to_line_numbers[end_node_id]
            # if not data_dependency_only:
            #     if edge_type == 'FLOWS_TO': #Control Flow edges
            #         adjacency_list[start_ln][0].add(end_ln)
            if edge_type == 'REACHES':  # Data Flow edges
                adjacency_list[start_ln][1].add(end_ln)
    return adjacency_list


def create_visual_graph(code, adjacency_list, file_name='test_graph', verbose=False):
    graph = Digraph('Code Property Graph')
    for ln in adjacency_list:
        graph.node(str(ln), str(ln) + '\t' + code[ln], shape='box')
        control_dependency, data_dependency = adjacency_list[ln]
        for anode in control_dependency:
            graph.edge(str(ln), str(anode), color='red')
        for anode in data_dependency:
            graph.edge(str(ln), str(anode), color='blue')
    graph.render(file_name, view=verbose)


def create_forward_slice(adjacency_list, line_no):
    sliced_lines = set()
    sliced_lines.add(line_no)
    stack = list()
    stack.append(line_no)
    while len(stack) != 0:
        cur = stack.pop()
        if cur not in sliced_lines:
            sliced_lines.add(cur)
        if len(adjacency_list) > line_no:
            adjacents = adjacency_list[cur]
            for node in adjacents:
                if node not in sliced_lines:
                    stack.append(node)
    sliced_lines = sorted(sliced_lines)
    return sliced_lines


def combine_control_and_data_adjacents(adjacency_list):
    cgraph = {}
    for ln in adjacency_list:
        cgraph[ln] = set()
        cgraph[ln] = cgraph[ln].union(adjacency_list[ln][0])
        cgraph[ln] = cgraph[ln].union(adjacency_list[ln][1])
    return cgraph


def invert_graph(adjacency_list):
    igraph = {}
    for ln in adjacency_list.keys():
        igraph[ln] = set()
    for ln in adjacency_list:
        adj = adjacency_list[ln]
        for node in adj:
            igraph[node].add(ln)
    return igraph


def create_backward_slice(adjacency_list, line_no):
    inverted_adjacency_list = invert_graph(adjacency_list)
    return create_forward_slice(inverted_adjacency_list, line_no)


if __name__ == '__main__':
    cpg_of_methods_path = './cpg_methods'
    codes_paths = './potential_methods'
    codes_criteria_path = './potential_methods'
    for root, dirname, _ in os.walk(cpg_of_methods_path):
        for sub_dir in dirname:
            criteria_cwd = os.path.join(codes_paths, sub_dir)
            codes_cwd = os.path.join(codes_paths, sub_dir)
            cwd = os.path.join(root, sub_dir)
            for child_root, child_dir, _ in os.walk(cwd):
                for _methods in child_dir:
                    path_to_criteria_file = os.path.join(
                        criteria_cwd, 'meta', _methods)
                    path_to_code_file = os.path.join(
                        codes_cwd, 'methods', _methods)
                    _cwd_dir = os.path.join(child_root, _methods)
                    cpg_nodes_edges = os.listdir(_cwd_dir)

                    edges_path = os.path.join(_cwd_dir, cpg_nodes_edges[0])
                    nodes_path = os.path.join(_cwd_dir, cpg_nodes_edges[1])

                    edges = read_csv(edges_path)
                    nodes = read_csv(nodes_path)

                    f_size = os.path.getsize(path_to_code_file)
                    if f_size < 900:
                        code = read_code_file(path_to_code_file)
                        slicing_criteria = read_criteria_file(
                            path_to_criteria_file)

                        node_indices, node_ids, line_numbers, node_id_to_ln = extract_nodes_with_location_info(
                            nodes)
                        adjacency_list = create_adjacency_list(
                            line_numbers, node_id_to_ln, edges)
                        combined_graph = combine_control_and_data_adjacents(
                            adjacency_list)

                        forward_output_path = os.path.join(
                            './sliced_methods', sub_dir)
                        if not os.path.exists(forward_output_path):
                            os.makedirs(forward_output_path)
                        random_ = []
                        if any(combined_graph) == True:
                            print(_methods)
                            for i, v in enumerate(slicing_criteria[0]):
                                if int(v) != 1:
                                    forward_sliced_lines = create_backward_slice(
                                        combined_graph, int(v))
                                    if len(forward_sliced_lines) < 3:
                                        fp = open(forward_output_path +
                                                  '/'+str(i)+_methods, 'w')
                                        for line in code:
                                            fp.write(code[line] + '\n')
                                        fp.close
                                    else:
                                        fp = open(forward_output_path +
                                                  '/'+str(i)+_methods, 'w')
                                        for ln in forward_sliced_lines:
                                            fp.write(code[ln] + '\n')
                                        fp.close()

                                    # forward_sliced_lines.insert(0, 1)
                                    # forward_sliced_lines.append(len(code))
                                    # if len(forward_sliced_lines) > 2:
                                    # if len(forward_sliced_lines) > 20:
                                    #     out_ = random.sample(forward_sliced_lines, 20)
                                    #     if int(v) not in out_:
                                    #         out_.insert(0, int(v))
                                    #     fp = open(forward_output_path + '/'+str(i)+_methods  , 'w')
                                    #     for ln in out_:
                                    #         fp.write(code[ln] + '\n')
                                    #     fp.close()

                        # print('============== Actual Code ====================')
                        # for ln in sorted(set(line_numbers)):
                        #     print(ln, '\t->', code[ln])
                        # print('===============================================')
                        # print('\n\nStarting slice for line %', int(v))
                        # print('-----------------------------------------------')
                        # print(code[int(v)])
                        # print('-----------------------------------------------')
                        # print('============== Forward Slice ==================')
                        # for ln in forward_sliced_lines:
                        #     print(ln, '\t->', code[ln])
                        # print('===============================================')
