import os
import shutil
from subprocess import call, run

db_list = {
    'REDAWN': '/home/nimashiri/benchmarks/run1/mutation_analysis/mutation_database.db',
    'REDAWZ': '/home/nimashiri/benchmarks/run2/mutation_analysis/mutation_database.db',
    'REC2A': '/home/nimashiri/benchmarks/run3/mutation_analysis/mutation_database.db',
    'RMFS': '/home/nimashiri/benchmarks/run4/mutation_analysis/mutation_database.db',
}

extracted_methods = {
    'REDAWN': '/home/nimashiri/benchmarks/run1/mutation_analysis/mutation_database.db',
    'REDAWZ': '/home/nimashiri/benchmarks/run2/mutation_analysis/mutation_database.db',
    'REC2A': '/home/nimashiri/benchmarks/run3/mutation_analysis/mutation_database.db',
    'RMFS': '/home/nimashiri/benchmarks/run4/mutation_analysis/mutation_database.db',
}

nicad_dir = '/home/nimashiri/NiCad-6.2/systems'


def calibrate(stmt):
  # a = 'a = (char *) palloc0(sizeof(int))'
    ls = []
    for char in stmt:
        ls.append(char)

    for i in range(len(ls)):
        for j in range(i+1, len(ls)):
            if ls[i].isalnum() and ls[j] == '(':
                temp = ''.join(ls[i]+ls[j])
                temp2 = ' '.join(ls[i]+ls[j])
                stmt = stmt.replace(temp, temp2)
            i += 1


def use_nicad(project_name):
    _command = os.path.join("./nicad6 functions c systems/", project_name)
    _command = _command + " " + "default"
    os.chdir("/home/nimashiri/NiCad-6.2/")
    call(_command, shell=True)


def filter_process(db_address):
    os.chdir('/home/nimashiri/vsprojects/DeepM/scripts/')
    call('python3 extractMethods.py inputDir OutputDir')


def main():
    project_dir = "/home/nimashiri/vsprojects/mutation_analysis/postgres"
    project_name = 'postgres'
    for root, operator_dir, _ in os.walk(project_dir):
        for op in operator_dir:
            db_address = db_list[op]
            current_op_dir = os.path.join(root, op)
            for status_dir in os.listdir(current_op_dir):
                current_status_dir = os.path.join(current_op_dir, status_dir)
                for _, _, files in os.walk(current_status_dir):
                    for _file in files:
                        current_file = os.path.join(current_status_dir, _file)
                        try:
                            dest = os.path.join(nicad_dir, project_name, op)
                            shutil.copy(current_file, dest)
                        except:
                            os.makedirs(dest)
                            shutil.copy(current_file, dest)
            use_nicad(project_name)
            filter_process(db_address)


if __name__ == '__main__':
    main()
