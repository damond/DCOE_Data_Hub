/*********************************************** 
*            spckg_DCOE_ABC_JOB                *
*   Author:  Doug Damon                        *
*   Date:  3/31/2000                           *
*  This package defines the Job interfaces to  *
*  the DCOE Data Hub ABC data model.           *
***********************************************/  

CREATE OR REPLACE PACKAGE BODY spckg_DCOE_ABC_JOB
as
  procedure sp_add_job(
    i_job_type_id       in       ABC_JOB.JOB_TYPE_ID%type,
    i_job_name          in       ABC_JOB.JOB_NAME%type,
    i_job_description   in       ABC_JOB.JOB_DESCRIPTION%type default null,
    i_active_indicator  in       ABC_JOB.ACTIVE_INDICATOR%type default 'Y',
    i_sytem_id          in       ABC_JOB.SYSTEM_ID%type,
    i_create_date       in       ABC_JOB.CREATE_DATE%type default null,
    i_create_user_id    in       ABC_JOB.CREATE_USER_ID%type default null,   
    o_job_id            out      ABC_JOB.JOB_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure inserts a new job into the   *
  *  JOB table and returns the JOB_ID for the    *
  *  newly created job.                          *
  ***********************************************/ 
  select JOB_ID_SEQ.nextval into o_job_id from dual;
  insert into ABC_JOB (JOB_ID,
                       JOB_TYPE_ID,
                       JOB_NAME, 
                       JOB_DESCRIPTION,
                       ACTIVE_INDICATOR,
                       SYSTEM_ID,
                       CREATE_DATE,
                       CREATE_USER_ID,
                       LAST_MOD_DATE,
                       LAST_MOD_USER_ID)
    values(o_job_id,
           i_job_type_id,
           i_job_name,
           i_job_description,
           DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
           i_sytem_id,
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_add_job;

  procedure sp_get_job(
    i_job_id       in        ABC_JOB.JOB_ID%type,    
    o_job          out       ABC_JOB%rowtype
  )
  is
  begin
  /***********************************************
  *  This procedure returns job details for a    *
  *  given JOB_ID.                               *
  ***********************************************/ 
  select * into o_job 
  from ABC_JOB
  where JOB_ID = i_job_id;
  if sql%rowcount = 0 then raise exp_jobid_notfound;
  end if;
  exception
    when exp_jobid_notfound then 
      rollback;
      raise_application_error(-20101, 'Job ' || i_job_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_get_job;

  procedure sp_update_job(
    i_job_id            in       ABC_JOB.JOB_ID%type,
    i_job_type_id       in       ABC_JOB.JOB_TYPE_ID%type,
    i_job_name          in       ABC_JOB.JOB_NAME%type,
    i_job_description   in       ABC_JOB.JOB_DESCRIPTION%type default null,
    i_active_indicator  in       ABC_JOB.ACTIVE_INDICATOR%type default 'Y',
    i_sytem_id          in       ABC_JOB.SYSTEM_ID%type,
    i_update_date       in       ABC_JOB.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_JOB.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing job in   *
  *  the JOB table.                              *
  ***********************************************/
  update ABC_JOB 
  set JOB_TYPE_ID = i_job_type_id,
      JOB_NAME = i_job_name, 
      JOB_DESCRIPTION = i_job_description,
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      SYSTEM_ID = i_sytem_id,
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where JOB_ID = i_job_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_jobid_notfound;
  end if;
  commit;
  exception
    when exp_jobid_notfound then 
      rollback;
      raise_application_error(-20101, 'Job ' || i_job_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_job;

  procedure sp_delete_job(
    i_job_id            in       ABC_JOB.JOB_ID%type,
    i_update_date       in       ABC_JOB.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_JOB.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing job in   *
  *  the JOB table.                              *
  ***********************************************/
  update ABC_JOB 
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where JOB_ID = i_job_id;
  if sql%rowcount = 0 then raise exp_jobid_notfound;
  end if;
  commit;
  exception
    when exp_jobid_notfound then 
      rollback;
      raise_application_error(-20101, 'Job ' || i_job_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_job;

  procedure sp_start_job(
    i_job_id            in       ABC_JOB.JOB_ID%type,
    i_job_start_time    in       ABC_JOB_EXECUTION.JOB_START_TIME%type default null,
    i_create_date       in       ABC_JOB_EXECUTION.CREATE_DATE%type default null,
    i_create_user_id    in       ABC_JOB_EXECUTION.CREATE_USER_ID%type default null,
    o_job_execution_id  out      ABC_JOB_EXECUTION.JOB_EXECUTION_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure starts a job by creating a   *
  *  a new record in JOB_EXECUTION and sets the  * 
  *  execution status to active.  Returns the    *
  *  JOB_EXECUTION_ID.                           *
  ***********************************************/ 
  select JOB_EXEC_ID_SEQ.nextval into o_job_execution_id from dual;
  insert into ABC_JOB_EXECUTION (JOB_EXECUTION_ID,
                                 JOB_ID,
                                 JOB_START_TIME, 
                                 RETURN_CODE_ID,
                                 EXECUTION_STATUS_ID,
                                 CREATE_DATE,
                                 CREATE_USER_ID,
                                 LAST_MOD_DATE,
                                 LAST_MOD_USER_ID)
    values(o_job_execution_id,
           i_job_id,
           DECODE(i_job_start_time,NULL, SYSDATE, i_job_start_time),
           cDefaultReturnCode, -- default execution return code
           cJob_Active, -- default execution status 'Active'
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_start_job;

  procedure sp_update_job_execution_status(
    i_job_execution_id    in       ABC_JOB_EXECUTION.JOB_EXECUTION_ID%type,
    i_execution_status_id in       ABC_JOB_EXECUTION.EXECUTION_STATUS_ID%type,
    i_update_date         in       ABC_JOB_EXECUTION.CREATE_DATE%type default null,
    i_update_user_id      in       ABC_JOB_EXECUTION.CREATE_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates the current status   *
  *  of a running job by setting the             *
  *  EXECUTION_STATUS_ID for the given           *
  *  JOB_EXECUTION_ID.                           *
  ***********************************************/ 
  update ABC_JOB_EXECUTION 
  set EXECUTION_STATUS_ID = i_execution_status_id,
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where JOB_EXECUTION_ID = i_job_execution_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_jobexecutionid_notfound;
  end if;
  commit;
  exception
    when exp_jobexecutionid_notfound then 
      rollback;
      raise_application_error(-20102, 'Job Execution ' || i_job_execution_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_job_execution_status;

  procedure sp_set_job_execution_complete(
    i_job_execution_id    in       ABC_JOB_EXECUTION.JOB_EXECUTION_ID%type,
    i_job_end_time        in       ABC_JOB_EXECUTION.JOB_END_TIME%type default null,
    i_execution_status_id in       ABC_JOB_EXECUTION.EXECUTION_STATUS_ID%type,
    i_return_code_id      in       ABC_JOB_EXECUTION.RETURN_CODE_ID%type,
    i_update_date         in       ABC_JOB_EXECUTION.CREATE_DATE%type default null,
    i_update_user_id      in       ABC_JOB_EXECUTION.CREATE_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure sets the job complete.  The  *
  *  EXECUTION_STATUS_ID and RETURN_CODE_ID will *
  *  indicate the final dispostion of the Job.   *
  *  This only indicates that the job is no      *
  *  longer running.                             * 
  ***********************************************/
  update ABC_JOB_EXECUTION 
  set JOB_END_TIME = DECODE(i_job_end_time,NULL, SYSDATE, i_job_end_time),
      EXECUTION_STATUS_ID = i_execution_status_id,
      RETURN_CODE_ID = i_return_code_id,
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where JOB_EXECUTION_ID = i_job_execution_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_jobexecutionid_notfound;
  end if;
  commit;
  exception
    when exp_jobexecutionid_notfound then 
      rollback;
      raise_application_error(-20102, 'Job Execution ' || i_job_execution_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_set_job_execution_complete;
END spckg_DCOE_ABC_JOB;


-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;
