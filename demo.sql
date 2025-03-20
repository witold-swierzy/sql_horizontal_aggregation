select department_id, json_arr_vc(last_name),
                      json_arr_vc(salary),
                      json_arr_n(salary),
                      hlist(last_name),
                      hlist(salary)
from employees
group by department_id