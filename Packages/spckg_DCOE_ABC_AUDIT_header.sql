/*********************************************** 
*            spckg_DCOE_ABC_BUS_PROC           *
*   Author:  Doug Damon                        *
*   Date:  5/17/2013                           *
*  This package defines the business process   *
*  interfaces to the DCOE Data Hub ABC data    *
*  model.                                      *
***********************************************/ 

CREATE OR REPLACE PACKAGE spckg_DCOE_ABC_AUDIT
as
-- Declare Types --
  exp_auditid_notfound             EXCEPTION;
  exp_auditresultid_notfound       EXCEPTION;
  exp_auditnotification_notfound   EXCEPTION;

-- Procedures --

-- AUDIT --
  /*************************************************
  *  This procedure inserts a new audit definition *
  *  into the AUDIT table and returns the AUDIT_ID *
  *  for the newly created audit definition.       *
  **************************************************/ 
  procedure sp_add_audit(
    i_audit_class_id             in       ABC_AUDIT.AUDIT_CLASS_ID%type,
    i_audit_source_id            in       ABC_AUDIT.AUDIT_SOURCE_ID%type,
    i_audit_name                 in       ABC_AUDIT.AUDIT_NAME%type,
    i_audit_description          in       ABC_AUDIT.AUDIT_DESCRIPTION%type default null,
    i_active_indicator           in       ABC_AUDIT.ACTIVE_INDICATOR%type default 'Y',
    i_create_date                in       ABC_AUDIT.CREATE_DATE%type default null,
    i_create_user_id             in       ABC_AUDIT.CREATE_USER_ID%type default null,    
    o_audit_id                   out      ABC_AUDIT.AUDIT_ID%type
  );

  /***********************************************
  *  This procedure returns job details for a    *
  *  given JOB_ID.                               *
  ***********************************************/ 
/*  procedure sp_get_job(
    io_job_id           in out    ABC_JOB.JOB_ID%type    
    o_job_type_id       out       ABC_JOB.JOB_TYPE_ID%type,
    o_job_type_name     out       ABC_JOB_TYPE.JOB_TYPE_NAME%type,
    o_job_name          out       ABC_JOB.JOB_NAME%type,
    o_job_description   out       ABC_JOB.JOB_DESCRIPTION%type,
    o_active_indicator  out       ABC_JOB.ACTIVE_INDICATOR%type,
    o_critical_flag     out       ABC_JOB.CRITICAL_FLAG%type,
    o_source_sytem_id   out       ABC_JOB.SOURCE_SYSTEM_ID%type,
    o_source_sys_name   out       ABC_SYSTEM.SYSTEM_NAME%type,
    o_create_date       out       ABC_JOB.CREATE_DATE%type,
    o_create_user_id    out       ABC_JOB.CREATE_USER_ID%type,    
    o_update_date       out       ABC_JOB.LAST_MOD_DATE%type,
    o_update_user_id    out       ABC_JOB.LAST_MOD_USER_ID%type
  ); 
 */

  /***********************************************
  *  This procedure updates an existing          *
  *  audit definition in the AUDIT table.        *
  ***********************************************/ 
  procedure sp_update_audit(
    i_audit_id                   in       ABC_AUDIT.AUDIT_ID%type,
    i_audit_class_id             in       ABC_AUDIT.AUDIT_CLASS_ID%type,
    i_audit_source_id            in       ABC_AUDIT.AUDIT_SOURCE_ID%type,
    i_audit_name                 in       ABC_AUDIT.AUDIT_NAME%type,
    i_audit_description          in       ABC_AUDIT.AUDIT_DESCRIPTION%type default null,
    i_active_indicator           in       ABC_AUDIT.ACTIVE_INDICATOR%type default 'Y',
    i_update_date                in       ABC_AUDIT.LAST_MOD_DATE%type default null,
    i_update_user_id             in       ABC_AUDIT.LAST_MOD_USER_ID%type default null
  );

  /*************************************************
  *  This procedure deletes an existing audit      *
  *  definition from the AUDIT table by setting    *
  *  the DELETE_FLAG = Y.                          *
  *************************************************/ 
  procedure sp_delete_audit(
    i_audit_id          in      ABC_AUDIT.AUDIT_ID%type,
    i_update_date       in      ABC_AUDIT.LAST_MOD_DATE%type default null,
    i_update_user_id    in      ABC_AUDIT.LAST_MOD_USER_ID%type default null    
  );
-- END AUDIT --

-- AUDIT NOTIFICATION XREF --
  /***********************************************
  *  This procedure adds a contact to notify for *
  *  a specified audit condition to the          *
  *  AUDIT_NOTIFICATION_XREF table.              *
  ***********************************************/ 
  procedure sp_add_audit_notification(
    i_audit_id                         in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_ID%type,
    i_contact_id                       in       ABC_AUDIT_NOTIFICATION_XREF.CONTACT_ID%type,
    i_notification_frequency           in       ABC_AUDIT_NOTIFICATION_XREF.NOTIFICATION_FREQUENCY%type,
    i_audit_notification_status_id     in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_NOTIFICATION_STATUS_ID%type,
    i_active_indicator                 in       ABC_AUDIT_NOTIFICATION_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_create_date                      in       ABC_AUDIT_NOTIFICATION_XREF.CREATE_DATE%type default null,
    i_create_user_id                   in       ABC_AUDIT_NOTIFICATION_XREF.CREATE_USER_ID%type default null    
  );


  /***************************************************
  *  This procedure updates an existing notification *
  *  that has been assigned to an audit definition   *
  *  in the ABC_AUDIT_NOTIFICATION_XREF table.       *
  ****************************************************/ 
    procedure sp_update_audit_notification(
    i_audit_id                         in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_ID%type,
    i_contact_id                       in       ABC_AUDIT_NOTIFICATION_XREF.CONTACT_ID%type,
    i_notification_frequency           in       ABC_AUDIT_NOTIFICATION_XREF.NOTIFICATION_FREQUENCY%type,
    i_audit_notification_status_id     in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_NOTIFICATION_STATUS_ID%type,
    i_active_indicator                 in       ABC_AUDIT_NOTIFICATION_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_update_date                      in       ABC_AUDIT_NOTIFICATION_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id                   in       ABC_AUDIT_NOTIFICATION_XREF.LAST_MOD_USER_ID%type default null
  );

  /************************************************
  *  This procedure deletes an existing contact   *
  *  that has been assigned to an audit for       *
  *  notification purposes from the               *
  *  ABC_AUDIT_NOTIFICATION_XREF table by setting *
  *  the DELETE_FLAG = Y.                         *
  ************************************************/ 
    procedure sp_delete_audit_notification(
    i_audit_id              in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_ID%type,
    i_contact_id            in       ABC_AUDIT_NOTIFICATION_XREF.CONTACT_ID%type,
    i_update_date           in       ABC_AUDIT_NOTIFICATION_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_AUDIT_NOTIFICATION_XREF.LAST_MOD_USER_ID%type default null
   );
-- END AUDIT NOTIFICATION XREF --

-- AUDIT RESULT --
  /**************************************************
  *  This procedure inserts a new audit result into *
  *  into the AUDIT_RESULT table and returns the    *
  *  AUDIT_RESULT_ID for the newly created result.  *
  ***************************************************/ 
  procedure sp_add_audit_result(
    i_execution_id               in       ABC_AUDIT_RESULT.EXECUTION_ID%type,
    i_audit_id                   in       ABC_AUDIT_RESULT.AUDIT_ID%type,
    i_audit_status_id            in       ABC_AUDIT_RESULT.AUDIT_STATUS_ID%type,
    i_audit_result_value         in       ABC_AUDIT_RESULT.AUDIT_RESULT_VALUE%type default null,
    i_audit_result_date          in       ABC_AUDIT_RESULT.AUDIT_RESULT_DATE%type default null,
    i_create_date                in       ABC_AUDIT_RESULT.CREATE_DATE%type default null,
    i_create_user_id             in       ABC_AUDIT_RESULT.CREATE_USER_ID%type default null,    
    o_audit_result_id            out      ABC_AUDIT_RESULT.AUDIT_RESULT_ID%type
  );

-- END AUDIT RESULT --

end spckg_DCOE_ABC_AUDIT;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;


