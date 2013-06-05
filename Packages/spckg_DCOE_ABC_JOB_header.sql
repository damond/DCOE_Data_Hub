/*********************************************** 
*            spckg_DCOE_ABC_JOB                *
*   Author:  Doug Damon                        *
*   Date:  3/31/2000                           *
*  This package defines the Job interfaces to  *
*  the DCOE Data Hub ABC data model.           *
***********************************************/ 

CREATE OR REPLACE PACKAGE spckg_DCOE_ABC_JOB
as
-- Declare Types --
  cJob_Active         CONSTANT INTEGER :=  1;
  cDefaultReturnCode  CONSTANT INTEGER :=  0; 

  exp_jobid_notfound           EXCEPTION;
  exp_jobexecutionid_notfound  EXCEPTION; 
  /***********************************************
  *  This procedure inserts a new job into the   *
  *  JOB table and returns the JOB_ID for the    *
  *  newly created job.                          *
  ***********************************************/ 
  procedure sp_add_job(
    i_job_type_id       in       ABC_JOB.JOB_TYPE_ID%type,
    i_job_name          in       ABC_JOB.JOB_NAME%type,
    i_job_description   in       ABC_JOB.JOB_DESCRIPTION%type default null,
    i_active_indicator  in       ABC_JOB.ACTIVE_INDICATOR%type default 'Y',
    i_sytem_id          in       ABC_JOB.SYSTEM_ID%type,
    i_create_date       in       ABC_JOB.CREATE_DATE%type default null,
    i_create_user_id    in       ABC_JOB.CREATE_USER_ID%type default null,    
    o_job_id            out      ABC_JOB.JOB_ID%type
  );

  /***********************************************
  *  This procedure returns job details for a    *
  *  given JOB_ID.                               *
  ***********************************************/ 
  procedure sp_get_job(
    i_job_id       in        ABC_JOB.JOB_ID%type,    
    o_job          out       ABC_JOB%rowtype
  ); 


  /***********************************************
  *  This procedure updates an existing job in   *
  *  the JOB table.                              *
  ***********************************************/ 
  procedure sp_update_job(
    i_job_id            in       ABC_JOB.JOB_ID%type,
    i_job_type_id       in       ABC_JOB.JOB_TYPE_ID%type,
    i_job_name          in       ABC_JOB.JOB_NAME%type,
    i_job_description   in       ABC_JOB.JOB_DESCRIPTION%type default null,
    i_active_indicator  in       ABC_JOB.ACTIVE_INDICATOR%type default 'Y',
    i_sytem_id          in       ABC_JOB.SYSTEM_ID%type,
    i_update_date       in       ABC_JOB.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_JOB.LAST_MOD_USER_ID%type default null     
  );

  /***********************************************
  *  This procedure deletes an existing job in   *
  *  the JOB table by setting the                * 
  *  DELETE_FLAG = Y.                            *
  ***********************************************/ 
  procedure sp_delete_job(
    i_job_id            in       ABC_JOB.JOB_ID%type,
    i_update_date       in       ABC_JOB.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_JOB.LAST_MOD_USER_ID%type default null     
  );

  /***********************************************
  *  This procedure starts a job by creating a   *
  *  a new record in JOB_EXECUTION and sets the  * 
  *  execution status to active.  Returns the    *
  *  JOB_EXECUTION_ID.                           *
  ***********************************************/ 
  procedure sp_start_job(
    i_job_id            in       ABC_JOB.JOB_ID%type,
    i_job_start_time    in       ABC_JOB_EXECUTION.JOB_START_TIME%type default null,
    i_create_date       in       ABC_JOB_EXECUTION.CREATE_DATE%type default null,
    i_create_user_id    in       ABC_JOB_EXECUTION.CREATE_USER_ID%type default null,
    o_job_execution_id  out      ABC_JOB_EXECUTION.JOB_EXECUTION_ID%type
  );

  /***********************************************
  *  This procedure returns the details for an   *
  *  executing job.                              *
  ***********************************************/ 
  procedure sp_get_job_execution(
    i_job_execution_id         in        ABC_JOB_EXECUTION.JOB_ID%type,    
    o_job_execution_status     out       ABC_JOB_EXECUTION%rowtype
  ); 

  /***********************************************
  *  This procedure updates the current status   *
  *  of a running job by setting the             *
  *  EXECUTION_STATUS_ID for the given           *
  *  JOB_EXECUTION_ID.                           *
  ***********************************************/ 
  procedure sp_update_job_execution_status(
    i_job_execution_id    in       ABC_JOB_EXECUTION.JOB_EXECUTION_ID%type,
    i_execution_status_id in       ABC_JOB_EXECUTION.EXECUTION_STATUS_ID%type,
    i_update_date         in       ABC_JOB_EXECUTION.CREATE_DATE%type default null,
    i_update_user_id      in       ABC_JOB_EXECUTION.CREATE_USER_ID%type default null
  );

  /***********************************************
  *  This procedure sets the job complete.  The  *
  *  EXECUTION_STATUS_ID and RETURN_CODE_ID will *
  *  indicate the final dispostion of the Job.   *
  *  This only indicates that the job is no      *
  *  longer running.                             * 
  ***********************************************/ 
  procedure sp_set_job_execution_complete(
    i_job_execution_id    in       ABC_JOB_EXECUTION.JOB_EXECUTION_ID%type,
    i_job_end_time        in       ABC_JOB_EXECUTION.JOB_END_TIME%type default null,
    i_execution_status_id in       ABC_JOB_EXECUTION.EXECUTION_STATUS_ID%type,
    i_return_code_id      in       ABC_JOB_EXECUTION.RETURN_CODE_ID%type,
    i_update_date         in       ABC_JOB_EXECUTION.CREATE_DATE%type default null,
    i_update_user_id      in       ABC_JOB_EXECUTION.CREATE_USER_ID%type default null
  );
end spckg_DCOE_ABC_JOB;


-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;


