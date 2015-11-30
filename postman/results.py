import sys
import math

n = int(sys.argv[1])
max_k = int(sys.argv[2])
filename = sys.argv[3]

def mean(xs):
  return sum(x for x in xs) / len(xs)

def variance(xs):
  mu = mean(xs)
  return sum(pow(x - mu,2) for x in xs)

accuracies = []
task_times = []
total_times = []
recalls = []
for i in range(1,max_k):
  # print i
  fname = '{0}/results1-{1}-{2}.pl'.format(filename,n,i)
  # print fname
  with open(fname,'r') as f:
    content = f.read().splitlines()
    try:
      accuracies.append(float(content[0]))
    except:
      pass
    # print content[0]

# print accuracies
mean_accuracy = mean(accuracies)
# mean_task_time = mean(task_times)
# mean_total_time = mean(total_times)
# mean_recall = mean(recalls)

var_accuracy = variance(accuracies)
# var_task_time = variance(task_times)
# var_total_time = variance(total_times)
# var_recall = variance(recalls)

std_accuracy = math.sqrt(var_accuracy)
# std_task_time = math.sqrt(var_task_time)
# std_total_time = math.sqrt(var_total_time)
# std_recall = math.sqrt(var_recall)

std_err_accuracy = std_accuracy / math.sqrt(len(accuracies))
# std_err_task_time = std_task_time / math.sqrt(len(task_times))
# std_err_total_time = std_total_time / math.sqrt(len(total_times))
# std_err_recall = std_recall / math.sqrt(len(recalls))

# print n, v


# if mode == 'a':
print "({0},{1}) +- (0,{2})".format(n,mean_accuracy,std_err_accuracy)
# elif mode == 'b':
#   print "({0},{1}) +- (0,{2})".format(x,mean_recall,std_err_recall)
# elif mode == 'c':
#   print "({0},{1}) +- (0,{2})".format(x,mean_task_time,(std_err_task_time / 2))
# elif mode == 'd':
#   print "({0},{1}) +- (0,{2})".format(x,mean_total_time,(std_err_total_time / 2))


