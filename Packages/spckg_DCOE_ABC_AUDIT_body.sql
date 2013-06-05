/*********************************************** 
*            spckg_DCOE_ABC_BUS_PROC           *
*   Author:  Doug Damon                        *
*   Date:  5/17/2013                           *
*  This package defines the business process   *
*  interfaces to the DCOE Data Hub ABC data    *
*  model.                                      *
***********************************************/  

CREATE OR REPLACE PACKAGE BODY spckg_DCOE_ABC_AUDIT
as
-- AUDIT --
  procedure sp_add_audit(
    i_audit_class_id             in       ABC_AUDIT.AUDIT_CLASS_ID%type,
    i_audit_source_id            in       ABC_AUDIT.AUDIT_SOURCE_ID%type,
    i_audit_name                 in       ABC_AUDIT.AUDIT_NAME%type,
    i_audit_description          in       ABC_AUDIT.AUDIT_DESCRIPTION%type default null,
    i_active_indicator           in       ABC_AUDIT.ACTIVE_INDICATOR%type default 'Y',
    i_create_date                in       ABC_AUDIT.CREATE_DATE%type default null,
    i_create_user_id             in       ABC_AUDIT.CREATE_USER_ID%type default null,    
    o_audit_id                   out      ABC_AUDIT.AUDIT_ID%type
  )
  is
  begin
  /*************************************************
  *  This procedure inserts a new audit definition *
  *  into the AUDIT table and returns the AUDIT_ID *
  *  for the newly created audit definition.       *
  **************************************************/
  select AUDIT_ID_SEQ.nextval into o_audit_id from dual;
  insert into ABC_AUDIT (AUDIT_ID,
                         AUDIT_CLASS_ID,
                         AUDIT_SOURCE_ID,
                         AUDIT_NAME, 
                         AUDIT_DESCRIPTION,
                         ACTIVE_INDICATOR,
                         CREATE_DATE,
                         CREATE_USER_ID,
                         LAST_MOD_DATE,
                         LAST_MOD_USER_ID)
    values(o_audit_id,
           i_audit_class_id,
           i_audit_source_id,
           i_audit_name,
           i_audit_description,
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
  end sp_add_audit;

  procedure sp_update_audit(
    i_audit_id                   in       ABC_AUDIT.AUDIT_ID%type,
    i_audit_class_id             in       ABC_AUDIT.AUDIT_CLASS_ID%type,
    i_audit_source_id            in       ABC_AUDIT.AUDIT_SOURCE_ID%type,
    i_audit_name                 in       ABC_AUDIT.AUDIT_NAME%type,
    i_audit_description          in       ABC_AUDIT.AUDIT_DESCRIPTION%type default null,
    i_active_indicator           in       ABC_AUDIT.ACTIVE_INDICATOR%type default 'Y',
    i_update_date                in       ABC_AUDIT.LAST_MOD_DATE%type default null,
    i_update_user_id             in       ABC_AUDIT.LAST_MOD_USER_ID%type default null    
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing          *
  *  audit definition in the AUDIT table.        *
  ***********************************************/ 
  update ABC_AUDIT 
  set AUDIT_CLASS_ID = i_audit_class_id,
      AUDIT_SOURCE_ID = i_audit_source_id,
      AUDIT_NAME = i_audit_name, 
      AUDIT_DESCRIPTION = i_audit_description,
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where AUDIT_ID = i_audit_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_auditid_notfound;
  end if;
  commit;
  exception
    when exp_auditid_notfound then 
      rollback;
      raise_application_error(-20114, 'Audit: ' || i_audit_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_audit;

  procedure sp_delete_audit(
    i_audit_id          in       ABC_AUDIT.AUDIT_ID%type,
    i_update_date       in       ABC_AUDIT.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_AUDIT.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /*************************************************
  *  This procedure deletes an existing audit      *
  *  definition from the AUDIT table by setting    *
  *  the DELETE_FLAG = Y.                          *
  *************************************************/
  update ABC_AUDIT 
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where AUDIT_ID = i_audit_id;
  if sql%rowcount = 0 then raise exp_auditid_notfound;
  end if;
  commit;
  exception
    when exp_auditid_notfound then 
      rollback;
      raise_application_error(-20114, 'Audit: ' || i_audit_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_audit;
-- END AUDIT --

-- AUDIT NOTIFICATION XREF --
  procedure sp_add_audit_notification(
    i_audit_id                         in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_ID%type,
    i_contact_id                       in       ABC_AUDIT_NOTIFICATION_XREF.CONTACT_ID%type,
    i_notification_frequency           in       ABC_AUDIT_NOTIFICATION_XREF.NOTIFICATION_FREQUENCY%type,
    i_audit_notification_status_id     in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_NOTIFICATION_STATUS_ID%type,
    i_active_indicator                 in       ABC_AUDIT_NOTIFICATION_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_create_date                      in       ABC_AUDIT_NOTIFICATION_XREF.CREATE_DATE%type default null,
    i_create_user_id                   in       ABC_AUDIT_NOTIFICATION_XREF.CREATE_USER_ID%type default null    
  )
  is
  begin
  /***********************************************
  *  This procedure adds a job to a business     *
  *  process in the BUS PROC_JOB_XREF table      *
  ***********************************************/ 
  insert into ABC_AUDIT_NOTIFICATION_XREF (AUDIT_ID,
                                           CONTACT_ID, 
                                           NOTIFICATION_FREQUENCY,
                                           AUDIT_NOTIFICATION_STATUS_ID,
                                           ACTIVE_INDICATOR,
                                           CREATE_DATE,
                                           CREATE_USER_ID,
                                           LAST_MOD_DATE,
                                           LAST_MOD_USER_ID)
    values(i_audit_id,
           i_contact_id,
           i_notification_frequency,
           i_audit_notification_status_id,
           DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  exception
    when others then 
      rollback;
      raise;
  end sp_add_audit_notification;

  procedure sp_update_audit_notification(
    i_audit_id                         in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_ID%type,
    i_contact_id                       in       ABC_AUDIT_NOTIFICATION_XREF.CONTACT_ID%type,
    i_notification_frequency           in       ABC_AUDIT_NOTIFICATION_XREF.NOTIFICATION_FREQUENCY%type,
    i_audit_notification_status_id     in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_NOTIFICATION_STATUS_ID%type,
    i_active_indicator                 in       ABC_AUDIT_NOTIFICATION_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_update_date                      in       ABC_AUDIT_NOTIFICATION_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id                   in       ABC_AUDIT_NOTIFICATION_XREF.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***************************************************
  *  This procedure updates an existing notification *
  *  that has been assigned to an audit definition   *
  *  in the ABC_AUDIT_NOTIFICATION_XREF table.       *
  ****************************************************/ 
  update ABC_AUDIT_NOTIFICATION_XREF 
  set NOTIFICATION_FREQUENCY = i_notification_frequency,
      AUDIT_NOTIFICATION_STATUS_ID = i_audit_notification_status_id,
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where AUDIT_ID = i_audit_id
        and
        CONTACT_ID = i_contact_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_auditnotification_notfound;
  end if;
  commit;
  exception
    when exp_auditnotification_notfound then 
      rollback;
      raise_application_error(-20116, 'Audit: ' || i_audit_id || ' Contact: ' || i_contact_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_audit_notification;

  procedure sp_delete_audit_notification(
    i_audit_id              in       ABC_AUDIT_NOTIFICATION_XREF.AUDIT_ID%type,
    i_contact_id            in       ABC_AUDIT_NOTIFICATION_XREF.CONTACT_ID%type,
    i_update_date           in       ABC_AUDIT_NOTIFICATION_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_AUDIT_NOTIFICATION_XREF.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /************************************************
  *  This procedure deletes an existing contact   *
  *  that has been assigned to an audit for       *
  *  notification purposes from the               *
  *  ABC_AUDIT_NOTIFICATION_XREF table by setting *
  *  the DELETE_FLAG = Y.                         *
  ************************************************/ 
  update ABC_AUDIT_NOTIFICATION_XREF 
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where AUDIT_ID = i_audit_id
        and
        CONTACT_ID = i_contact_id;
  if sql%rowcount = 0 then raise exp_auditnotification_notfound;
  end if;
  commit;
  exception
    when  exp_auditnotification_notfound then 
      rollback;
      raise_application_error(-20116, 'Audit: ' || i_audit_id || ' Contact: ' || i_contact_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_audit_notification;
-- END AUDIT NOTIFICATION XREF --

-- AUDIT RESULT --
  procedure sp_add_audit_result(
    i_execution_id               in       ABC_AUDIT_RESULT.EXECUTION_ID%type,
    i_audit_id                   in       ABC_AUDIT_RESULT.AUDIT_ID%type,
    i_audit_status_id            in       ABC_AUDIT_RESULT.AUDIT_STATUS_ID%type,
    i_audit_result_value         in       ABC_AUDIT_RESULT.AUDIT_RESULT_VALUE%type default null,
    i_audit_result_date          in       ABC_AUDIT_RESULT.AUDIT_RESULT_DATE%type default null,
    i_create_date                in       ABC_AUDIT_RESULT.CREATE_DATE%type default null,
    i_create_user_id             in       ABC_AUDIT_RESULT.CREATE_USER_ID%type default null,    
    o_audit_result_id            out      ABC_AUDIT_RESULT.AUDIT_RESULT_ID%type
  )
  is
  begin
  /*************************************************
  *  This procedure inserts a new audit definition *
  *  into the AUDIT table and returns the AUDIT_ID *
  *  for the newly created audit definition.       *
  **************************************************/
  select AUDIT_RESULT_ID_SEQ.nextval into o_audit_result_id from dual;
  insert into ABC_AUDIT_RESULT (AUDIT_RESULT_ID,
                            EXECUTION_ID,
                            AUDIT_ID,
                            AUDIT_STATUS_ID, 
                            AUDIT_RESULT_VALUE,
                            AUDIT_RESULT_DATE,
                            CREATE_DATE,
                            CREATE_USER_ID,
                            LAST_MOD_DATE,
                            LAST_MOD_USER_ID)
    values(o_audit_result_id,
           i_execution_id,
           i_audit_id,
           i_audit_status_id,
           i_audit_result_value,
           DECODE(i_audit_result_date,NULL, SYSDATE, i_audit_result_date),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_add_audit_result;
-- END AUDIT RESULT --

END spckg_DCOE_ABC_AUDIT;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;
