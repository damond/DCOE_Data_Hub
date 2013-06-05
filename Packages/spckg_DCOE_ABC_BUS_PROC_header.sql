/*********************************************** 
*            spckg_DCOE_ABC_BUS_PROC           *
*   Author:  Doug Damon                        *
*   Date:  5/17/2013                           *
*  This package defines the business process   *
*  interfaces to the DCOE Data Hub ABC data    *
*  model.                                      *
***********************************************/ 

CREATE OR REPLACE PACKAGE spckg_DCOE_ABC_BUS_PROC
as
-- Declare Types --
  exp_busprocid_notfound           EXCEPTION;
  exp_contactid_notfound           EXCEPTION;
  exp_organizationid_notfound      EXCEPTION;
  exp_busprocjob_notfound          EXCEPTION;
  exp_busproccontact_notfound      EXCEPTION;

-- Procedures --

-- ORGANIZATION --
  /***********************************************
  *  This procedure inserts a new organization   *
  *  into the ORGANIZATION table and returns the * 
  *  ORGANIZATION_ID for the newly created job.  *
  ***********************************************/ 
  procedure sp_add_organization(
    i_organization_name          in       ABC_ORGANIZATION.ORGANIZATION_NAME%type,
    i_organization_description   in       ABC_ORGANIZATION.ORGANIZATION_DESCRIPTION%type default null,
    i_active_indicator           in       ABC_ORGANIZATION.ACTIVE_INDICATOR%type default 'Y',
    i_create_date                in       ABC_ORGANIZATION.CREATE_DATE%type default null,
    i_create_user_id             in       ABC_ORGANIZATION.CREATE_USER_ID%type default null,    
    o_organization_id            out      ABC_ORGANIZATION.ORGANIZATION_ID%type
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
  *  organization in the ORGANIZATION table.     *
  ***********************************************/ 
  procedure sp_update_organization(
    i_organization_id            in       ABC_ORGANIZATION.ORGANIZATION_ID%type,
    i_organization_name          in       ABC_ORGANIZATION.ORGANIZATION_NAME%type,
    i_organization_description   in       ABC_ORGANIZATION.ORGANIZATION_DESCRIPTION%type default null,
    i_active_indicator           in       ABC_ORGANIZATION.ACTIVE_INDICATOR%type default 'Y',
    i_update_date                in       ABC_ORGANIZATION.LAST_MOD_DATE%type default null,
    i_update_user_id             in       ABC_ORGANIZATION.LAST_MOD_USER_ID%type default null
  );

  /***********************************************
  *  This procedure deletes an existing          *
  *  organization in the ORGANIZATION table by   *
  *  setting the DELETE_FLAG = Y.                *
  ***********************************************/ 
  procedure sp_delete_organization(
    i_organization_id   in       ABC_ORGANIZATION.ORGANIZATION_ID%type,
    i_update_date       in       ABC_ORGANIZATION.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_ORGANIZATION.LAST_MOD_USER_ID%type default null    
  );
-- END ORGANIZATION --

-- CONTACT --
  /***********************************************
  *  This procedure inserts a new contact        *
  *  into the ABC_CONTACT table and returns the  * 
  *  CONTACT_ID for the newly created job.       *
  ***********************************************/ 
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
  *  This procedure updates an existing contact  *
  *  in the ABC_CONTACT table.                   *
  ***********************************************/ 
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
  );

  /***********************************************
  *  This procedure deletes an existing          *
  *  contact in the CONTACT table by setting the *
  *  DELETE_FLAG = Y.                            *
  ***********************************************/ 
  procedure sp_delete_contact(
    i_contact_id        in       ABC_CONTACT.CONTACT_ID%type,
    i_update_date       in       ABC_CONTACT.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_CONTACT.LAST_MOD_USER_ID%type default null    
  );
-- END CONTACT --

-- BUSINESS PROCESS --
  /***********************************************
  *  This procedure inserts a new business       *
  *  process into the BUSINESS PROCESS table and *
  *  returns the BUSINESS_PROCESS_ID for the     *
  *  newly created process.                      *
  ***********************************************/ 
  procedure sp_add_business_process(
    i_business_process_name          in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_NAME%type,
    i_business_process_description   in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_DESCRIPTION%type default null,
    i_active_indicator               in       ABC_BUSINESS_PROCESS.ACTIVE_INDICATOR%type default 'Y',
    i_organization                   in       ABC_BUSINESS_PROCESS.ORGANIZATION_ID%type,
    i_create_date                    in       ABC_BUSINESS_PROCESS.CREATE_DATE%type default null,
    i_create_user_id                 in       ABC_BUSINESS_PROCESS.CREATE_USER_ID%type default null,    
    o_business_process_id            out      ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_ID%type
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
  *  This procedure updates an existing business *
  *  process in the BUSINESS_PROCESS table.      *
  ***********************************************/ 
  procedure sp_update_business_process(
    i_business_process_id            in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_ID%type,
    i_business_process_name          in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_NAME%type,
    i_business_process_description   in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_DESCRIPTION%type default null,
    i_active_indicator               in       ABC_BUSINESS_PROCESS.ACTIVE_INDICATOR%type default 'Y',
    i_organization_id                in       ABC_BUSINESS_PROCESS.ORGANIZATION_ID%type,
    i_update_date                    in       ABC_BUSINESS_PROCESS.LAST_MOD_DATE%type default null,
    i_update_user_id                 in       ABC_BUSINESS_PROCESS.LAST_MOD_USER_ID%type default null     
  );

  /***********************************************
  *  This procedure deletes an existing business *
  *  process from the BUSINESS PROCESS table by  *
  *  setting the DELETE_FLAG = Y.                *
  ***********************************************/ 
  procedure sp_delete_business_process(
    i_business_process_id   in       ABC_BUSINESS_PROCESS.BUSINESS_PROCESS_ID%type,
    i_update_date           in       ABC_BUSINESS_PROCESS.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUSINESS_PROCESS.LAST_MOD_USER_ID%type default null    
  );
-- END BUSINESS PROCESS --

-- BUSINESS PROCESS JOB XREF --
  /***********************************************
  *  This procedure adds a job to a business     *
  *  process in the BUS PROC_JOB_XREF table      *
  ***********************************************/ 
  procedure sp_add_job_to_bus_proc(
    i_business_process_id   in       ABC_BUS_PROC_JOB_XREF.BUSINESS_PROCESS_ID%type,
    i_job_id                in       ABC_BUS_PROC_JOB_XREF.JOB_ID%type,
    i_job_sequence          in       ABC_BUS_PROC_JOB_XREF.JOB_SEQUENCE%type,
    i_active_indicator      in       ABC_BUS_PROC_JOB_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_create_date           in       ABC_BUS_PROC_JOB_XREF.CREATE_DATE%type default null,
    i_create_user_id        in       ABC_BUS_PROC_JOB_XREF.CREATE_USER_ID%type default null    
  );


  /***********************************************
  *  This procedure updates an existing job that *
  *  has been assigned to a business process in  *
  *  the ABC_BUS_PROC_JOB_XREF table.            *
  ***********************************************/ 
    procedure sp_update_bus_proc_Job(
    i_business_process_id   in       ABC_BUS_PROC_JOB_XREF.BUSINESS_PROCESS_ID%type,
    i_job_id                in       ABC_BUS_PROC_JOB_XREF.JOB_ID%type,
    i_job_sequence          in       ABC_BUS_PROC_JOB_XREF.JOB_SEQUENCE%type,
    i_active_indicator      in       ABC_BUS_PROC_JOB_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_update_date           in       ABC_BUS_PROC_JOB_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUS_PROC_JOB_XREF.LAST_MOD_USER_ID%type default null
  );

  /************************************************
  *  This procedure deletes an existing job that  *
  *  has been assigned to a business process from *
  *  the ABC_BUS_PROC_JOB_XREF table by setting   *
  *  the DELETE_FLAG = Y.                         *
  ************************************************/ 
    procedure sp_delete_bus_proc_job(
    i_business_process_id   in       ABC_BUS_PROC_JOB_XREF.BUSINESS_PROCESS_ID%type,
    i_job_id                in       ABC_BUS_PROC_JOB_XREF.JOB_ID%type,
    i_update_date           in       ABC_BUS_PROC_JOB_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUS_PROC_JOB_XREF.LAST_MOD_USER_ID%type default null
   );
-- END BUSINESS PROCESS JOB XREF --

-- BUSINESS PROCESS CONTACT XREF --
  /***********************************************
  *  This procedure adds a contact to a business *
  *  process in the BUS_PROC_CNTCT_XREF table    *
  ***********************************************/ 
  procedure sp_add_contact_to_bus_proc(
    i_business_process_id   in       ABC_BUS_PROC_CNTCT_XREF.BUSINESS_PROCESS_ID%type,
    i_contact_id            in       ABC_BUS_PROC_CNTCT_XREF.CONTACT_ID%type,
    i_active_indicator      in       ABC_BUS_PROC_CNTCT_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_create_date           in       ABC_BUS_PROC_CNTCT_XREF.CREATE_DATE%type default null,
    i_create_user_id        in       ABC_BUS_PROC_CNTCT_XREF.CREATE_USER_ID%type default null    
  );

  /**********************************************
  *  This procedure updates an existing contact *
  *  that has been assigned to a business       *
  *  process in the ABC_BUS_PROC_JOB_XREF       *
  *  table.                                     *
  **********************************************/ 
    procedure sp_update_bus_proc_contact(
    i_business_process_id   in       ABC_BUS_PROC_CNTCT_XREF.BUSINESS_PROCESS_ID%type,
    i_contact_id            in       ABC_BUS_PROC_CNTCT_XREF.CONTACT_ID%type,
    i_active_indicator      in       ABC_BUS_PROC_CNTCT_XREF.ACTIVE_INDICATOR%type default 'Y',
    i_update_date           in       ABC_BUS_PROC_CNTCT_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUS_PROC_CNTCT_XREF.LAST_MOD_USER_ID%type default null
  );

  /************************************************
  *  This procedure deletes an existing contact   *
  *  that has been assigned to a business process *
  *  from the ABC_BUS_PROC_JOB_XREF table by      *
  *  setting the DELETE_FLAG = Y.                 *
  ************************************************/ 
    procedure sp_delete_bus_proc_contact(
    i_business_process_id   in       ABC_BUS_PROC_CNTCT_XREF.BUSINESS_PROCESS_ID%type,
    i_contact_id            in       ABC_BUS_PROC_CNTCT_XREF.CONTACT_ID%type,
    i_update_date           in       ABC_BUS_PROC_CNTCT_XREF.LAST_MOD_DATE%type default null,
    i_update_user_id        in       ABC_BUS_PROC_CNTCT_XREF.LAST_MOD_USER_ID%type default null
   );
-- END BUSINESS PROCESS CONTACT XREF --
end spckg_DCOE_ABC_BUS_PROC;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;


