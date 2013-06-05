/*********************************************** 
*            spckg_DCOE_ABC_BUS_PROC           *
*   Author:  Doug Damon                        *
*   Date:  5/17/2013                           *
*  This package defines the business process   *
*  interfaces to the DCOE Data Hub ABC data    *
*  model.                                      *
***********************************************/  

CREATE OR REPLACE PACKAGE BODY spckg_DCOE_ABC_BUS_PROC
as
-- ORGANIZATION --
  procedure sp_add_organization(
    i_organization_name          in       ABC_ORGANIZATION.ORGANIZATION_NAME%type,
    i_organization_description   in       ABC_ORGANIZATION.ORGANIZATION_DESCRIPTION%type default null,
    i_active_indicator           in       ABC_ORGANIZATION.ACTIVE_INDICATOR%type default 'Y',
    i_create_date                in       ABC_ORGANIZATION.CREATE_DATE%type default null,
    i_create_user_id             in       ABC_ORGANIZATION.CREATE_USER_ID%type default null,    
    o_organization_id            out      ABC_ORGANIZATION.ORGANIZATION_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure inserts a new job into the   *
  *  JOB table and returns the JOB_ID for the    *
  *  newly created job.                          *
  ***********************************************/ 
  select ORGANIZATION_ID_SEQ.nextval into o_organization_id from dual;
  insert into ABC_ORGANIZATION (ORGANIZATION_ID,
                                ORGANIZATION_NAME, 
                                ORGANIZATION_DESCRIPTION,
                                ACTIVE_INDICATOR,
                                CREATE_DATE,
                                CREATE_USER_ID,
                                LAST_MOD_DATE,
                                LAST_MOD_USER_ID)
    values(o_organization_id,
           i_organization_name,
           i_organization_description,
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
  end sp_add_organization;

  procedure sp_update_organization(
    i_organization_id            in       ABC_ORGANIZATION.ORGANIZATION_ID%type,
    i_organization_name          in       ABC_ORGANIZATION.ORGANIZATION_NAME%type,
    i_organization_description   in       ABC_ORGANIZATION.ORGANIZATION_DESCRIPTION%type default null,
    i_active_indicator           in       ABC_ORGANIZATION.ACTIVE_INDICATOR%type default 'Y',
    i_update_date                in       ABC_ORGANIZATION.LAST_MOD_DATE%type default null,
    i_update_user_id             in       ABC_ORGANIZATION.LAST_MOD_USER_ID%type default null    
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing          *
  *  organization in the ORGANIZATION table.     *
  ***********************************************/
  update ABC_ORGANIZATION 
  set ORGANIZATION_NAME = i_organization_name, 
      ORGANIZATION_DESCRIPTION = i_organization_description,
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where ORGANIZATION_ID = i_organization_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_organizationid_notfound;
  end if;
  commit;
  exception
    when exp_organizationid_notfound then 
      rollback;
      raise_application_error(-20108, 'Organization: ' || i_organization_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_organization;

  procedure sp_delete_organization(
    i_organization_id   in       ABC_ORGANIZATION.ORGANIZATION_ID%type,
    i_update_date       in       ABC_ORGANIZATION.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_ORGANIZATION.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure deletes an existing          *
  *  organization in the ORGANIZATION table by   *
  *  setting the DELETE_FLAG = Y.                *
  ***********************************************/ 
  update ABC_ORGANIZATION 
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where ORGANIZATION_ID = i_organization_id;
  if sql%rowcount = 0 then raise exp_organizationid_notfound;
  end if;
  commit;
  exception
    when exp_organizationid_notfound then 
      rollback;
      raise_application_error(-20108, 'Organization: ' || i_organization_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_organization;
-- END ORGANIZATION --

-- CONTACT --
  procedure sp_add_contact(
    i_contact_type_id       in       ABC_CONTACT.CONTACT_TYPE_ID%type,
    i_contact_name          in       ABC_CONTACT.CONTACT_NAME%type,
    i_contact_email         in       ABC_CONTACT.CONTACT_EMAIL%type default null,
    i_phone_primary         in       ABC_CONTACT.PHONE_PRIMARY%type default null,
    i_phone_secondary       in       ABC_CONTACT.PHONE_SECONDARY%type default null,
    i_active_indicator      in       ABC_CONTACT.ACTIVE_INDICATOR%type default 'Y',
    i_create_date           in       ABC_CONTACT.CREATE_DATE%type default null,
    i_create_user_id        in       ABC_CONTACT.CREATE_USER_ID%type default null,    
    o_contact_id            out      ABC_CONTACT.CONTACT_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure inserts a new contact        *
  *  into the ABC_CONTACT table and returns the  * 
  *  CONTACT_ID for the newly created job.       *
  ***********************************************/ 
  select CONTACT_ID_SEQ.nextval into o_contact_id from dual;
  insert into ABC_CONTACT (CONTACT_ID,
                           CONTACT_TYPE_ID,
                           CONTACT_NAME, 
                           CONTACT_EMAIL,
                           PHONE_PRIMARY,
                           PHONE_SECONDARY,
                           ACTIVE_INDICATOR,
                           CREATE_DATE,
                           CREATE_USER_ID,
                           LAST_MOD_DATE,
                           LAST_MOD_USER_ID)
    values(o_contact_id,
           i_contact_type_id,
           i_contact_name,
           i_contact_email,
           i_phone_primary,
           i_phone_secondary,
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
  end sp_add_contact;

  procedure sp_update_contact(
    i_contact_id            in       ABC_CONTACT.CONTACT_ID%type,
    i_contact_type_id       in       ABC_CONTACT.CONTACT_TYPE_ID%type,
    i_contact_name          in       ABC_CONTACT.CONTACT_NAME%type,
    i_contact_email         in       ABC_CONTACT.CONTACT_EMAIL%type default null,
    i_phone_primary         in       ABC_CONTACT.PHONE_PRIMARY%type default null,
    i_phone_secondary       in       ABC_CONTACT.PHONE_SECONDARY%type default null,
    i_active_indicator      in       ABC_CONTACT.ACTIVE_INDICATOR%type default 'Y',
    i_update_date           in       ABC_CONTACT.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_CONTACT.LAST_MOD_USER_ID%type default null  
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing contact  *
  *  in the ABC_CONTACT table.                   *
  ***********************************************/ 
  update ABC_CONTACT 
  set CONTACT_TYPE_ID = i_contact_type_id,
      CONTACT_NAME = i_contact_name, 
      CONTACT_EMAIL = i_contact_email,
      PHONE_PRIMARY = i_phone_primary,
      PHONE_SECONDARY = i_phone_secondary,
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where CONTACT_ID = i_contact_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_contactid_notfound;
  end if;
  commit;
  exception
    when exp_contactid_notfound then 
      rollback;
      raise_application_error(-20109, 'Contact: ' || i_contact_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_contact;

  procedure sp_delete_contact(
    i_contact_id        in       ABC_CONTACT.CONTACT_ID%type,
    i_update_date       in       ABC_CONTACT.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_CONTACT.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure deletes an existing          *
  *  organization in the ORGANIZATION table by   *
  *  setting the DELETE_FLAG = Y.                *
  ***********************************************/ 
  update ABC_CONTACT 
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where CONTACT_ID = i_contact_id;
  if sql%rowcount = 0 then raise exp_contactid_notfound;
  end if;
  commit;
  exception
    when exp_contactid_notfound then 
      rollback;
      raise_application_error(-20109, 'Contact: ' || i_contact_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_contact;
-- END CONTACT --

-- BUSINESS PROCESS --
  procedure sp_add_business_process(
    i_business_process_name          in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_NAME%type,
    i_business_process_description   in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_DESCRIPTION%type default null,
    i_active_indicator               in       ABC_BUSINESS_PROCESS.ACTIVE_INDICATOR%type default 'Y',
    i_organization                   in       ABC_BUSINESS_PROCESS.ORGANIZATION_ID%type,
    i_create_date                    in       ABC_BUSINESS_PROCESS.CREATE_DATE%type default null,
    i_create_user_id                 in       ABC_BUSINESS_PROCESS.CREATE_USER_ID%type default null,    
    o_business_process_id            out      ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure inserts a new business       *
  *  process into the BUSINESS PROCESS table and *
  *  returns the BUSINESS_PROCESS_ID for the     *
  *  newly created process.                      *
  ***********************************************/
  select BUSINESS_PROCESS_ID_SEQ.nextval into  o_business_process_id from dual;
  insert into ABC_BUSINESS_PROCESS (BUSINESS_PROCESS_ID,
                       BUSINESS_PROCESS_NAME, 
                       BUSINESS_PROCESS_DESCRIPTION,
                       ACTIVE_INDICATOR,
                       ORGANIZATION_ID,
                       CREATE_DATE,
                       CREATE_USER_ID,
                       LAST_MOD_DATE,
                       LAST_MOD_USER_ID)
    values(o_business_process_id,
           i_business_process_name,
           i_business_process_description,
           DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
           i_organization,
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_add_business_process;


  procedure sp_update_business_process(
    i_business_process_id            in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_ID%type,
    i_business_process_name          in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_NAME%type,
    i_business_process_description   in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_DESCRIPTION%type default null,
    i_active_indicator               in       ABC_BUSINESS_PROCESS.ACTIVE_INDICATOR%type default 'Y',
    i_organization_id                in       ABC_BUSINESS_PROCESS.ORGANIZATION_ID%type,
    i_update_date                    in       ABC_BUSINESS_PROCESS.LAST_MOD_DATE%type default null,
    i_update_user_id                 in       ABC_BUSINESS_PROCESS.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing business *
  *  process in the BUSINESS_PROCESS table.      *
  ***********************************************/ 
  update ABC_BUSINESS_PROCESS 
  set BUSINESS_PROCESS_NAME = i_business_process_name, 
      BUSINESS_PROCESS_DESCRIPTION = i_business_process_description,
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      ORGANIZATION_ID = i_organization_id,

      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where BUSINESS_PROCESS_ID = i_business_process_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_busprocid_notfound;
  end if;
  commit;
  exception
    when exp_busprocid_notfound then 
      rollback;
      raise_application_error(-20110, 'Business Process: ' || i_business_process_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_business_process;


  procedure sp_delete_business_process(
    i_business_process_id   in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_ID%type,
    i_update_date           in       ABC_BUSINESS_PROCESS.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUSINESS_PROCESS.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure deletes an existing business *
  *  process from the BUSINESS PROCESS table by  *
  *  setting the DELETE_FLAG = Y.                *
  ***********************************************/ 
  update ABC_BUSINESS_PROCESS 
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where BUSINESS_PROCESS_ID = i_business_process_id;
  if sql%rowcount = 0 then raise exp_busprocid_notfound;
  end if;
  commit;
  exception
    when exp_busprocid_notfound then 
      rollback;
      raise_application_error(-20110, 'Business Process: ' || i_business_process_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_business_process;
-- END BUSINESS PROCESS --

-- BUSINESS PROCESS JOB XREF --
  procedure sp_add_job_to_bus_proc(
    i_business_process_id   in       ABC_BUS_PROC_JOB_XREF.BUSINESS_PROCESS_ID%type,
    i_job_id                in       ABC_BUS_PROC_JOB_XREF.JOB_ID%type,
    i_job_sequence          in       ABC_BUS_PROC_JOB_XREF.JOB_SEQUENCE%type,
    i_active_indicator      in       ABC_BUS_PROC_JOB_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_create_date           in       ABC_BUS_PROC_JOB_XREF.CREATE_DATE%type default null,
    i_create_user_id        in       ABC_BUS_PROC_JOB_XREF.CREATE_USER_ID%type default null    
  )
  is
  begin
  /***********************************************
  *  This procedure adds a job to a business     *
  *  process in the BUS PROC_JOB_XREF table      *
  ***********************************************/ 
  insert into ABC_BUS_PROC_JOB_XREF (BUSINESS_PROCESS_ID,
                                     JOB_ID, 
                                     JOB_SEQUENCE,
                                     ACTIVE_INDICATOR,
                                     CREATE_DATE,
                                     CREATE_USER_ID,
                                     LAST_MOD_DATE,
                                     LAST_MOD_USER_ID)
    values(i_business_process_id,
           i_job_id,
           i_job_sequence,
           DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  exception
    when others then 
      rollback;
      raise;
  end sp_add_job_to_bus_proc;

  procedure sp_update_bus_proc_Job(
    i_business_process_id   in       ABC_BUS_PROC_JOB_XREF.BUSINESS_PROCESS_ID%type,
    i_job_id                in       ABC_BUS_PROC_JOB_XREF.JOB_ID%type,
    i_job_sequence          in       ABC_BUS_PROC_JOB_XREF.JOB_SEQUENCE%type,
    i_active_indicator      in       ABC_BUS_PROC_JOB_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_update_date           in       ABC_BUS_PROC_JOB_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUS_PROC_JOB_XREF.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing job that *
  *  has been assigned to a business process in  *
  *  the ABC_BUS_PROC_JOB_XREF table.            *
  ***********************************************/ 
  update ABC_BUS_PROC_JOB_XREF 
  set JOB_SEQUENCE = i_job_sequence, 
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where BUSINESS_PROCESS_ID = i_business_process_id
        and
        JOB_ID = i_job_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_busprocjob_notfound;
  end if;
  commit;
  exception
    when exp_busprocjob_notfound then 
      rollback;
      raise_application_error(-20111, 'Business Process: ' || i_business_process_id || ' Job: ' || i_job_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_bus_proc_Job;

  procedure sp_delete_bus_proc_job(
    i_business_process_id   in       ABC_BUS_PROC_JOB_XREF.BUSINESS_PROCESS_ID%type,
    i_job_id                in       ABC_BUS_PROC_JOB_XREF.JOB_ID%type,
    i_update_date           in       ABC_BUS_PROC_JOB_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUS_PROC_JOB_XREF.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /************************************************
  *  This procedure deletes an existing job that  *
  *  has been assigned to a business process from *
  *  the ABC_BUS_PROC_JOB_XREF table by setting   *
  *  the DELETE_FLAG = Y.                         *
  ************************************************/ 
  update ABC_BUS_PROC_JOB_XREF 
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where BUSINESS_PROCESS_ID = i_business_process_id
        and
        JOB_ID = i_job_id;
  if sql%rowcount = 0 then raise exp_busprocjob_notfound;
  end if;
  commit;
  exception
    when exp_busprocjob_notfound then 
      rollback;
      raise_application_error(-20111, 'Business Process: ' || i_business_process_id || ' Job: ' || i_job_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_bus_proc_job;
-- END BUSINESS PROCESS JOB XREF --

-- BUSINESS PROCESS CONTACT XREF --
  procedure sp_add_contact_to_bus_proc(
    i_business_process_id   in       ABC_BUS_PROC_CNTCT_XREF.BUSINESS_PROCESS_ID%type,
    i_contact_id            in       ABC_BUS_PROC_CNTCT_XREF.CONTACT_ID%type,
    i_active_indicator      in       ABC_BUS_PROC_CNTCT_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_create_date           in       ABC_BUS_PROC_CNTCT_XREF.CREATE_DATE%type default null,
    i_create_user_id        in       ABC_BUS_PROC_CNTCT_XREF.CREATE_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure adds a contact to a business *
  *  process in the BUS_PROC_CNTCT_XREF table    *
  ***********************************************/  
  insert into ABC_BUS_PROC_CNTCT_XREF (BUSINESS_PROCESS_ID,
                                       CONTACT_ID, 
                                       ACTIVE_INDICATOR,
                                       CREATE_DATE,
                                       CREATE_USER_ID,
                                       LAST_MOD_DATE,
                                       LAST_MOD_USER_ID)
    values(i_business_process_id,
           i_contact_id,
           DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  exception
    when others then 
      rollback;
      raise;
  end sp_add_contact_to_bus_proc;

  procedure sp_update_bus_proc_contact(
    i_business_process_id   in       ABC_BUS_PROC_CNTCT_XREF.BUSINESS_PROCESS_ID%type,
    i_contact_id            in       ABC_BUS_PROC_CNTCT_XREF.CONTACT_ID%type,
    i_active_indicator      in       ABC_BUS_PROC_CNTCT_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_update_date           in       ABC_BUS_PROC_CNTCT_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUS_PROC_CNTCT_XREF.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /**********************************************
  *  This procedure updates an existing contact *
  *  that has been assigned to a business       *
  *  process in the ABC_BUS_PROC_JOB_XREF       *
  *  table.                                     *
  **********************************************/ 
  update ABC_BUS_PROC_CNTCT_XREF 
  set ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where BUSINESS_PROCESS_ID = i_business_process_id
        and
        CONTACT_ID = i_contact_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_busproccontact_notfound;
  end if;
  commit;
  exception
    when exp_busproccontact_notfound then 
      rollback;
      raise_application_error(-20112, 'Business Process: ' || i_business_process_id || ' Contact: ' || i_contact_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_bus_proc_contact;

  procedure sp_delete_bus_proc_contact(
    i_business_process_id   in       ABC_BUS_PROC_CNTCT_XREF.BUSINESS_PROCESS_ID%type,
    i_contact_id            in       ABC_BUS_PROC_CNTCT_XREF.CONTACT_ID%type,
    i_update_date           in       ABC_BUS_PROC_CNTCT_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUS_PROC_CNTCT_XREF.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /************************************************
  *  This procedure deletes an existing contact   *
  *  that has been assigned to a business process *
  *  from the ABC_BUS_PROC_JOB_XREF table by      *
  *  setting the DELETE_FLAG = Y.                 *
  ************************************************/ 
  update ABC_BUS_PROC_CNTCT_XREF 
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where BUSINESS_PROCESS_ID = i_business_process_id
        and
        CONTACT_ID = i_contact_id;
  if sql%rowcount = 0 then raise exp_busproccontact_notfound;
  end if;
  commit;
  exception
    when exp_busproccontact_notfound then 
      rollback;
      raise_application_error(-20112, 'Business Process: ' || i_business_process_id || ' Contact: ' || i_contact_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_bus_proc_contact;
-- END BUSINESS PROCESS CONTACT XREF --

END spckg_DCOE_ABC_BUS_PROC;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;
