import re
import os

output_path = "./all_methods"
input_path = './put'


def loadtxt(_path):
    with open(_path, "r") as f:
        data_dict = f.readlines()
    return data_dict


def writetxt(fileList, project_name, master_file):
    master_file = master_file.replace('.txt', "")
    out_path = os.path.join(output_path, project_name, master_file)
    if not os.path.exists(out_path):
        os.makedirs(out_path)
    if len(fileList[0]) > 0:
        with open(out_path + "/%s.c" % (fileList[0][0]), 'w') as f:
            # with open(output_path + fileList[0] + ".c", 'w') as f:
            for line in fileList[1]:
                f.writelines(line)


def txtParser():
    for root, project_list, _ in os.walk(input_path):
        for project_name in project_list:
            project_path = os.path.join(root, project_name)
            for master_root, master_dir, master_file_list in os.walk(project_path):
                for master_file in master_file_list:
                    cwd_file = os.path.join(master_root, master_file)
                    data_ = loadtxt(cwd_file)

                    print(cwd_file)

                    temp = []
                    methodList = []

                    flag = False
                    for x in data_:
                        if "<source file=" in x:
                            _filename = re.findall(r'file="(.*?)"', x)
                            flag = True
                            pass
                        elif flag:
                            methodName = re.findall(
                                r'([a-zA-Z_{1}][a-zA-Z0-9_]+)\s(?=\()', x)
                            if len(methodName) == 1:
                                file_n = _filename[0] + "/" + methodName[0]
                                temp.append(x)
                                # print(methodName[0])
                            else:
                                print("hi")
                            flag = False
                        elif "</source>" in x:
                            methodList.append([file_n, temp])
                            # if len(methodName) > 0:
                            writetxt([methodName, temp],
                                     project_name, master_file)
                            temp = []
                        else:
                            temp.append(x)


if __name__ == '__main__':
    txtParser()
