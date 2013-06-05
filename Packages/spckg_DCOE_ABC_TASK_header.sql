/*********************************************** 
*            spckg_DCOE_ABC_TASK               *
*   Author:  Doug Damon                        *
*   Date:  5/16/2013                           *
*  This package defines the Job interfaces to  *
*  the DCOE Data Hub ABC data model.           *
***********************************************/ 

CREATE OR REPLACE PACKAGE spckg_DCOE_ABC_TASK
as
-- Declare Types --
  cTask_Active         CONSTANT INTEGER :=  1;
  cDefaultReturnCode   CONSTANT INTEGER :=  0; 

  exp_jobid_notfound           EXCEPTION;
  exp_taskid_notfound          EXCEPTION;
  exp_jobexecutionid_notfound  EXCEPTION; 
  exp_taskexecutionid_notfound  EXCEPTION;
  /***********************************************
  *  This procedure inserts a new job into the   *
  *  JOB table and returns the JOB_ID for the    *
  *  newly created job.                          *
  ***********************************************/ 
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
  );

  /***********************************************
  *  This procedure returns job details for a    *
  *  given JOB_ID.                               *
  ***********************************************/ 
/*  procedure sp_get_job(
    io_job_id           in out    ABC_TASK.JOB_ID%type    
    o_job_type_id       out       ABC_TASK.JOB_TYPE_ID%type,
    o_job_type_name     out       ABC_TASK_TYPE.JOB_TYPE_NAME%type,
    o_job_name          out       ABC_TASK.JOB_NAME%type,
    o_job_description  out       ABC_TASK.JOB_DESCRIPTION%type,
    o_active_indicator  out       ABC_TASK.ACTIVE_INDICATOR%type,
    o_critical_flag     out       ABC_TASK.CRITICAL_FLAG%type,
    o_source_sytem_id   out       ABC_TASK.SOURCE_SYSTEM_ID%type,
    o_source_sys_name   out       ABC_SYSTEM.SYSTEM_NAME%type,
    o_create_date       out       ABC_TASK.CREATE_DATE%type,
    o_create_user_id    out       ABC_TASK.CREATE_USER_ID%type,    
    o_update_date       out       ABC_TASK.LAST_MOD_DATE%type,
    o_update_user_id    out       ABC_TASK.LAST_MOD_USER_ID%type
  ); 
 */

  /***********************************************
  *  This procedure updates an existing job in   *
  *  the JOB table.                              *
  ***********************************************/ 
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
  );

  /***********************************************
  *  This procedure deletes an existing job in   *
  *  the JOB table by setting the                * 
  *  DELETE_FLAG = Y.                            *
  ***********************************************/ 
  procedure sp_delete_task(
    i_task_id           in       ABC_JOB_TASK.JOB_TASK_ID%type,
    i_update_date       in       ABC_JOB_TASK.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_JOB_TASK.LAST_MOD_USER_ID%type default null     
  );

 /***********************************************
  *  This procedure starts a task by creating a  *
  *  a new record in JOB_TASK_EXECUTION and      *
  *  sets the execution status to active.        * 
  *   Returns the JOB_TASK_EXECUTION_ID.         *
  ***********************************************/ 
  procedure sp_start_task(
    i_job_execution_id  in       ABC_JOB_EXECUTION.JOB_EXECUTION_ID%type,
    i_task_id           in       ABC_JOB_TASK.JOB_TASK_ID%type,
    i_task_start_time   in       ABC_TASK_EXECUTION.TASK_START_TIME%type default null,
    i_create_date       in       ABC_TASK_EXECUTION.CREATE_DATE%type default null,
    i_create_user_id    in       ABC_TASK_EXECUTION.CREATE_USER_ID%type default null,
    o_task_execution_id out      ABC_TASK_EXECUTION.JOB_TASK_EXECUTION_ID%type
  );

  /***********************************************
  *  This procedure updates the current status   *
  *  of a running job by setting the             *
  *  EXECUTION_STATUS_ID for the given           *
  *  JOB_EXECUTION_ID.                           *
  ***********************************************/ 
  procedure sp_update_task_exec_status(
    i_task_execution_id   in       ABC_TASK_EXECUTION.JOB_TASK_EXECUTION_ID%type,
    i_execution_status_id in       ABC_TASK_EXECUTION.EXECUTION_STATUS_ID%type,
    i_update_date         in       ABC_TASK_EXECUTION.LAST_MOD_DATE%type default null,
    i_update_user_id      in       ABC_TASK_EXECUTION.LAST_MOD_USER_ID%type default null
  );

  /***********************************************
  *  This procedure sets the job complete.  The  *
  *  EXECUTION_STATUS_ID and RETURN_CODE_ID will *
  *  indicate the final dispostion of the Job.   *
  *  This only indicates that the job is no      *
  *  longer running.                             * 
  ***********************************************/ 
  procedure sp_set_task_execution_complete(
    i_task_execution_id   in       ABC_TASK_EXECUTION.JOB_TASK_EXECUTION_ID%type,
    i_task_end_time       in       ABC_TASK_EXECUTION.TASK_END_TIME%type default null,
    i_execution_status_id in       ABC_TASK_EXECUTION.EXECUTION_STATUS_ID%type,
    i_return_code_id      in       ABC_TASK_EXECUTION.RETURN_CODE_ID%type,
    i_update_date         in       ABC_TASK_EXECUTION.LAST_MOD_DATE%type default null,
    i_update_user_id      in       ABC_TASK_EXECUTION.LAST_MOD_USER_ID%type default null
  );
end spckg_DCOE_ABC_TASK;


-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;


