/*********************************************** 
*            spckg_DCOE_ABC_TASK               *
*   Author:  Doug Damon                        *
*   Date:  5/16/2013                           *
*  This package defines the Job interfaces to  *
*  the DCOE Data Hub ABC data model.           *
***********************************************/ 

CREATE OR REPLACE PACKAGE BODY "DCOEHUB"."SPCKG_DCOE_ABC_TASK"
as
  procedure sp_add_task(
    i_job_id               in       ABC_JOB.JOB_ID%type,
    i_task_type_id         in       ABC_JOB_TASK.TASK_TYPE_ID%type,
    i_task_name            in       ABC_JOB_TASK.TASK_NAME%type,
    i_task_description     in       ABC_JOB_TASK.TASK_DESCRIPTION%type default null,
    i_task_command         in       ABC_JOB_TASK.TASK_COMMAND%type default null,
    i_task_sequence        in       ABC_JOB_TASK.TASK_SEQUENCE%type default null,
    i_critical_path_flag   in       ABC_JOB_TASK.CRITICAL_PATH_FLAG%type default 'Y',
    i_active_indicator     in       ABC_JOB_TASK.ACTIVE_INDICATOR%type default 'Y',
    i_create_date          in       ABC_JOB_TASK.CREATE_DATE%type default null,
    i_create_user_id       in       ABC_JOB_TASK.CREATE_USER_ID%type default null,    
    o_task_id              out      ABC_JOB_TASK.JOB_TASK_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure inserts a new job into the   *
  *  JOB table and returns the JOB_ID for the    *
  *  newly created job.                          *
  ***********************************************/ 
  select JOB_TASK_ID_SEQ.nextval into o_task_id from dual;
  insert into ABC_JOB_TASK (JOB_TASK_ID,
                            JOB_ID,
                            TASK_TYPE_ID,
                            TASK_NAME, 
                            TASK_DESCRIPTION,
                            TASK_COMMAND,
                            TASK_SEQUENCE,
                            CRITICAL_PATH_FLAG,
                            ACTIVE_INDICATOR,
                            CREATE_DATE,
                            CREATE_USER_ID,
                            LAST_MOD_DATE,
                            LAST_MOD_USER_ID)
    values(o_task_id,
           i_job_id,
           i_task_type_id,
           i_task_name,
           i_task_description,
           i_task_command,
           i_task_sequence,
           DECODE(i_critical_path_flag,NULL,'Y', i_critical_path_flag),
           DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_add_task;

  procedure sp_update_task(
    i_task_id              in       ABC_JOB_TASK.JOB_TASK_ID%type,
    i_job_id               in       ABC_JOB_TASK.JOB_ID%type,
    i_task_type_id         in       ABC_JOB_TASK.TASK_TYPE_ID%type,
    i_task_name            in       ABC_JOB_TASK.TASK_NAME%type,
    i_task_description     in       ABC_JOB_TASK.TASK_DESCRIPTION%type default null,
    i_task_command         in       ABC_JOB_TASK.TASK_COMMAND%type default null,
    i_task_sequence        in       ABC_JOB_TASK.TASK_SEQUENCE%type default null,
    i_critical_path_flag   in       ABC_JOB_TASK.CRITICAL_PATH_FLAG%type default 'Y',
    i_active_indicator     in       ABC_JOB_TASK.ACTIVE_INDICATOR%type default 'Y',
    i_update_date          in       ABC_JOB_TASK.LAST_MOD_DATE%type default null,
    i_update_user_id       in       ABC_JOB_TASK.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing job in   *
  *  the JOB table.                              *
  ***********************************************/
  update ABC_JOB_TASK 
  set JOB_ID = i_job_id,
      TASK_TYPE_ID = i_task_type_id,
      TASK_NAME = i_task_name, 
      TASK_DESCRIPTION = i_task_description,
      TASK_COMMAND = i_task_command,
      TASK_SEQUENCE = i_task_sequence,
      CRITICAL_PATH_FLAG = i_critical_path_flag,
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where JOB_TASK_ID = i_task_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_taskid_notfound;
  end if;
  commit;
  exception
    when exp_taskid_notfound then 
      rollback;
      raise_application_error(-20103, 'Task ' || i_task_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_task;

  procedure sp_delete_task(
    i_task_id           in       ABC_JOB_TASK.JOB_TASK_ID%type,
    i_update_date       in       ABC_JOB_TASK.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_JOB_TASK.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing task in  *
  *  the JOB_TASK table.                         *
  ***********************************************/
  update ABC_JOB_TASK
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where JOB_TASK_ID = i_task_id;
  if sql%rowcount = 0 then raise exp_taskid_notfound;
  end if;
  commit;
  exception
    when exp_taskid_notfound then 
      rollback;
      raise_application_error(-20103, 'Task ' || i_task_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_task;

  procedure sp_start_task(
    i_job_execution_id  in       ABC_JOB_EXECUTION.JOB_EXECUTION_ID%type,
    i_task_id           in       ABC_JOB_TASK.JOB_TASK_ID%type,
    i_task_start_time   in       ABC_TASK_EXECUTION.TASK_START_TIME%type default null,
    i_create_date       in       ABC_TASK_EXECUTION.CREATE_DATE%type default null,
    i_create_user_id    in       ABC_TASK_EXECUTION.CREATE_USER_ID%type default null,
    o_task_execution_id out      ABC_TASK_EXECUTION.JOB_TASK_EXECUTION_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure starts a task by creating a  *
  *  a new record in JOB_TASK_EXECUTION and      *
  *  sets the execution status to active.        * 
  *   Returns the JOB_TASK_EXECUTION_ID.         *
  ***********************************************/ 
  select JOB_TASK_EXEC_ID_SEQ.nextval into o_task_execution_id from dual;
  insert into ABC_TASK_EXECUTION (JOB_TASK_EXECUTION_ID,
                                  JOB_EXECUTION_ID,
                                  TASK_START_TIME, 
                                  JOB_TASK_ID,
                                  RETURN_CODE_ID,
                                  EXECUTION_STATUS_ID,
                                  CREATE_DATE,
                                  CREATE_USER_ID,
                                  LAST_MOD_DATE,
                                  LAST_MOD_USER_ID)
    values(o_task_execution_id,
           i_job_execution_id,
           DECODE(i_task_start_time,NULL, SYSDATE, i_task_start_time),
           i_task_id, 
           cDefaultReturnCode, -- default execution return code
           cTask_Active, -- default execution status 'Active'
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_start_task;

  procedure sp_update_task_exec_status(
    i_task_execution_id   in       ABC_TASK_EXECUTION.JOB_TASK_EXECUTION_ID%type,
    i_execution_status_id in       ABC_TASK_EXECUTION.EXECUTION_STATUS_ID%type,
    i_update_date         in       ABC_TASK_EXECUTION.LAST_MOD_DATE%type default null,
    i_update_user_id      in       ABC_TASK_EXECUTION.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates the current status   *
  *  of a running task by setting the            *
  *  EXECUTION_STATUS_ID for the given           *
  *  JOB_TASK_EXECUTION_ID.                      *
  ***********************************************/ 
  update ABC_TASK_EXECUTION 
  set EXECUTION_STATUS_ID = i_execution_status_id,
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where JOB_TASK_EXECUTION_ID = i_task_execution_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_taskexecutionid_notfound;
  end if;
  commit;
  exception
    when exp_taskexecutionid_notfound then 
      rollback;
      raise_application_error(-20104, 'Job Task Execution ' || i_task_execution_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_task_exec_status;

  procedure sp_set_task_execution_complete(
    i_task_execution_id   in       ABC_TASK_EXECUTION.JOB_TASK_EXECUTION_ID%type,
    i_task_end_time       in       ABC_TASK_EXECUTION.TASK_END_TIME%type default null,
    i_execution_status_id in       ABC_TASK_EXECUTION.EXECUTION_STATUS_ID%type,
    i_return_code_id      in       ABC_TASK_EXECUTION.RETURN_CODE_ID%type,
    i_update_date         in       ABC_TASK_EXECUTION.LAST_MOD_DATE%type default null,
    i_update_user_id      in       ABC_TASK_EXECUTION.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure sets the task complete.  The *
  *  EXECUTION_STATUS_ID and RETURN_CODE_ID will *
  *  indicate the final dispostion of the Task.  *
  *  This only indicates that the task is no     *
  *  longer running.                             * 
  ***********************************************/
  update ABC_TASK_EXECUTION 
  set TASK_END_TIME = DECODE(i_task_end_time,NULL, SYSDATE, i_task_end_time),
      EXECUTION_STATUS_ID = i_execution_status_id,
      RETURN_CODE_ID = i_return_code_id,
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where JOB_TASK_EXECUTION_ID = i_task_execution_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_taskexecutionid_notfound;
  end if;
  commit;
  exception
    when exp_taskexecutionid_notfound then 
      rollback;
      raise_application_error(-20102, 'Job Task Execution ' || i_task_execution_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_set_task_execution_complete;
END spckg_DCOE_ABC_TASK;


-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;

