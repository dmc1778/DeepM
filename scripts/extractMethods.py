import re
import os

output_path = "E:\\apply\\york\\Courses\\EECS 6444\\final project\\source\\all_methods\\grep"


def getpath():
    _cwd = os.getcwd()
    os.chdir("..")
    _file_ = []
    o = [os.path.join(_cwd, o) for o in os.listdir(_cwd) if os.path.isdir(os.path.join(_cwd, o))]
    for item in o:
        if os.path.exists(item + '\\grep-multithread_functions.txt'):
            _file_.append(item + '\\grep-multithread_functions.txt')
    return _file_[0]


def loadtxt():
    desired_file = getpath()
    with open(desired_file, "r") as f:
        data_dict = f.readlines()
    return data_dict


def writetxt(fileList):
    # _path = "{}/{}.c".format(output_path, fileList[0])
    with open(output_path + "/%s.c" % (fileList[0]), 'w') as f:
    # with open(output_path + fileList[0] + ".c", 'w') as f:
        for line in fileList[1]:
            f.writelines(line)
    f.close


def txtParser():
    temp = []
    methodList = []

    data_ = loadtxt()

    flag = False
    for x in data_:
        if "<source file=" in x:
            _filename = re.findall(r'file="(.*?)"', x)
            flag = True
            pass
        elif flag:
            methodName = re.findall(r'([a-zA-Z_{1}][a-zA-Z0-9_]+)\s(?=\()', x)
            if len(methodName[0]) > 0:
                file_n = _filename[0] + "/" + methodName[0]
                temp.append(x)
                print(methodName[0])
            else:
                print("hi")
            flag = False
        elif "</source>" in x:
            methodList.append([file_n, temp])
            #if len(methodName) > 0:
            writetxt([methodName, temp])
            temp = []
        else:
            temp.append(x)
    return methodList


if __name__ == '__main__':
    methodList = txtParser()
    print(len(methodList))
