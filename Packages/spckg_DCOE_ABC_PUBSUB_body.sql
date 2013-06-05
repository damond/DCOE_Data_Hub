/*********************************************** 
*            spckg_DCOE_ABC_PUBSUB             *
*   Author:  Doug Damon                        *
*   Date:  5/16/2013                           *
*  This package defines the PUB/SUB interfaces *
*  tothe DCOE Data Hub ABC data model.         *
***********************************************/  

CREATE OR REPLACE PACKAGE BODY spckg_DCOE_ABC_PUBSUB
as
  procedure sp_add_publisher(
    i_data_entity_id          in       ABC_PUBLISHER.DATA_ENTITY_ID%type,
    i_pub_system_id           in       ABC_PUBLISHER.PUBLISHER_SYSTEM_ID%type,
    i_publisher_name          in       ABC_PUBLISHER.PUBLISHER_NAME%type,
    i_publisher_description   in       ABC_PUBLISHER.PUBLISHER_DESCRIPTION%type default null,
    i_active_indicator        in       ABC_PUBLISHER.ACTIVE_INDICATOR%type default 'Y',
    i_create_date             in       ABC_PUBLISHER.CREATE_DATE%type default null,
    i_create_user_id          in       ABC_PUBLISHER.CREATE_USER_ID%type default null,    
    o_publisher_id            out      ABC_PUBLISHER.PUBLISHER_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure inserts a new publisher into *
  *  the PUBLISHER table and returns the         *
  *  PUBLISHER_ID for the newly created          *
  *  publisher.                                  *
  ***********************************************/ 
  select PUBLISHER_ID_SEQ.nextval into o_publisher_id from dual;
  insert into ABC_PUBLISHER (PUBLISHER_ID,
                             DATA_ENTITY_ID,
                             PUBLISHER_SYSTEM_ID,
                             PUBLISHER_NAME, 
                             PUBLISHER_DESCRIPTION,
                             ACTIVE_INDICATOR,
                             CREATE_DATE,
                             CREATE_USER_ID,
                             LAST_MOD_DATE,
                             LAST_MOD_USER_ID)
    values(o_publisher_id,
           i_data_entity_id,
           i_pub_system_id,
           i_publisher_name,
           i_publisher_description,
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
  end sp_add_publisher;

  procedure sp_update_publisher(
    i_publisher_id           in       ABC_PUBLISHER.PUBLISHER_ID%type,
    i_data_entity_id         in       ABC_PUBLISHER.DATA_ENTITY_ID%type,
    i_pub_system_id          in       ABC_PUBLISHER.PUBLISHER_SYSTEM_ID%type,
    i_publisher_name         in       ABC_PUBLISHER.PUBLISHER_NAME%type,
    i_publisher_description  in       ABC_PUBLISHER.PUBLISHER_DESCRIPTION%type default null,
    i_active_indicator       in       ABC_PUBLISHER.ACTIVE_INDICATOR%type default 'Y',
    i_update_date            in       ABC_PUBLISHER.LAST_MOD_DATE%type default null,
    i_update_user_id         in       ABC_PUBLISHER.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing          *
  *  publisher in the PUBLISHER table.           *
  ***********************************************/
  update ABC_PUBLISHER 
  set DATA_ENTITY_ID = i_data_entity_id,
      PUBLISHER_SYSTEM_ID = i_pub_system_id,
      PUBLISHER_NAME = i_publisher_name, 
      PUBLISHER_DESCRIPTION = i_publisher_description,
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where PUBLISHER_ID = i_publisher_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_pubid_notfound;
  end if;
  commit;
  exception
    when exp_pubid_notfound then 
      rollback;
      raise_application_error(-20103, 'Publisher ' || i_publisher_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_publisher;

  procedure  sp_delete_publisher(
    i_publisher_id      in       ABC_PUBLISHER.PUBLISHER_ID%type,
    i_update_date       in       ABC_PUBLISHER.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_PUBLISHER.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing task in  *
  *  the JOB_TASK table.                         *
  ***********************************************/
  update ABC_PUBLISHER
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where PUBLISHER_ID = i_publisher_id;
  if sql%rowcount = 0 then raise exp_pubid_notfound;
  end if;
  commit;
  exception
    when exp_pubid_notfound then 
      rollback;
      raise_application_error(-20103, 'Publisher ' || i_publisher_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_publisher;

  procedure sp_start_publication(
    i_job_execution_id      in       ABC_PUBLICATION_STATUS.JOB_EXECUTION_ID%type,
    i_publisher_id          in       ABC_PUBLICATION_STATUS.PUBLISHER_ID%type,
    i_create_date           in       ABC_PUBLICATION_STATUS.CREATE_DATE%type default null,
    i_create_user_id        in       ABC_PUBLICATION_STATUS.CREATE_USER_ID%type default null,
    o_publisher_status_id   out      ABC_PUBLICATION_STATUS.PUBLISHER_STATUS_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure starts a task by creating a  *
  *  a new record in JOB_TASK_EXECUTION and      *
  *  sets the execution status to active.        * 
  *   Returns the JOB_TASK_EXECUTION_ID.         *
  ***********************************************/ 
  select PUBLISHER_STATUS_ID_SEQ.nextval into o_publisher_status_id from dual;
  insert into ABC_PUBLICATION_STATUS (PUBLISHER_STATUS_ID,
                                      JOB_EXECUTION_ID,
                                      PUBLISHER_ID,
                                      PUB_SUB_STATUS_ID,
                                      CREATE_DATE,
                                      CREATE_USER_ID,
                                      LAST_MOD_DATE,
                                      LAST_MOD_USER_ID)
    values(o_publisher_status_id,
           i_job_execution_id,
           i_publisher_id,
           cPubSub_Active, -- default publication status 'Active'
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_start_publication;

  procedure sp_set_publication_status(
    i_publisher_status_id    in       ABC_PUBLICATION_STATUS.PUBLISHER_STATUS_ID%type,
    i_publication_status_id  in       ABC_PUBLICATION_STATUS.PUB_SUB_STATUS_ID%type,
    i_update_date            in       ABC_PUBLICATION_STATUS.LAST_MOD_DATE%type default null,
    i_update_user_id         in       ABC_PUBLICATION_STATUS.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates the current status   *
  *  of a publication by setting the             *
  *  PUB_SUB_ID for the given                    *
  *  PUBLISHER_STATUS_ID.                        *
  ***********************************************/
  update ABC_PUBLICATION_STATUS 
  set PUB_SUB_STATUS_ID = i_publication_status_id,
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where PUBLISHER_STATUS_ID = i_publisher_status_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_publicationid_notfound;
  end if;
  commit;
  exception
    when exp_publicationid_notfound then 
      rollback;
      raise_application_error(-20104, 'Publication ' || i_publisher_status_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_set_publication_status;

  procedure sp_set_publication_statistics(
    i_publisher_status_id    in       ABC_PUB_SUB_STATISTICS.PUB_SUB_STATUS_ID%type,
    i_rows_read              in       ABC_PUB_SUB_STATISTICS.ROWS_READ%type default null,
    i_rows_published         in       ABC_PUB_SUB_STATISTICS.ROWS_WRITTEN%type default null,
    i_rows_rejected          in       ABC_PUB_SUB_STATISTICS.ROWS_REJECTED%type default null,
    i_data_volume_read       in       ABC_PUB_SUB_STATISTICS.DATA_VOLUME_READ%type default null,
    i_data_volume_published  in       ABC_PUB_SUB_STATISTICS.DATA_VOLUME_WRITTEN%type default null,
    i_create_date            in       ABC_PUB_SUB_STATISTICS.CREATE_DATE%type default null,
    i_create_user_id         in       ABC_PUB_SUB_STATISTICS.CREATE_USER_ID%type default null,
    o_pub_statistics_id      out      ABC_PUB_SUB_STATISTICS.PUB_SUB_STATS_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure sets the load statistics     *
  *  for the job task run.                       *
  *  Data volume is in KB.                       *
  ***********************************************/ 
  select PUB_SUB_STATS_ID_SEQ.nextval into o_pub_statistics_id from dual;
  insert into ABC_PUB_SUB_STATISTICS (PUB_SUB_STATS_ID,
                                      PUB_SUB_TYPE,
                                      PUB_SUB_STATUS_ID,
                                      ROWS_READ,
                                      ROWS_WRITTEN,
                                      ROWS_REJECTED,
                                      DATA_VOLUME_READ,
                                      DATA_VOLUME_WRITTEN,
                                      CREATE_DATE,
                                      CREATE_USER_ID,
                                      LAST_MOD_DATE,
                                      LAST_MOD_USER_ID)
    values(o_pub_statistics_id,
           cPub_Type,
           i_publisher_status_id,
           i_rows_read,
           i_rows_published,
           i_rows_rejected,
           i_data_volume_read,
           i_data_volume_published,
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_set_publication_statistics;

  procedure sp_set_publication_published(
    i_publisher_status_id    in       ABC_PUBLICATION_STATUS.PUBLISHER_STATUS_ID%type,
    i_publication_status_id  in       ABC_PUBLICATION_STATUS.PUB_SUB_STATUS_ID%type default null,
    i_publication_date       in       ABC_PUBLICATION_STATUS.PUBLISH_DATE%type default null,
    i_update_date            in       ABC_PUBLICATION_STATUS.LAST_MOD_DATE%type default null,
    i_update_user_id         in       ABC_PUBLICATION_STATUS.LAST_MOD_USER_ID%type default null
  )
  is 
  begin
  /***********************************************
  *  This procedure sets the data set as         *
  *  available for consumption.                  *
  ***********************************************/ 
  update ABC_PUBLICATION_STATUS 
  set PUB_SUB_STATUS_ID = DECODE(i_publication_status_id, NULL, cPubSub_Published, i_publication_status_id),
      PUBLISH_DATE = DECODE(i_publication_date, NULL, SYSDATE, i_publication_date),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where PUBLISHER_STATUS_ID = i_publisher_status_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_publicationid_notfound;
  end if;
  commit;
  exception
    when exp_publicationid_notfound then 
      rollback;
      raise_application_error(-20104, 'Publication ' || i_publisher_status_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_set_publication_published;

  procedure sp_add_subscriber(
    i_publisher_id             in       ABC_SUBSCRIBER.PUBLISHER_ID%type,
    i_sub_system_id            in       ABC_SUBSCRIBER.SUBSCRIBER_SYSTEM_ID%type,
    i_subscriber_name          in       ABC_SUBSCRIBER.SUBSCRIBER_NAME%type,
    i_subscriber_description   in       ABC_SUBSCRIBER.SUBSCRIBER_DESCRIPTION%type default null,
    i_active_indicator         in       ABC_SUBSCRIBER.ACTIVE_INDICATOR%type default 'Y',
    i_create_date              in       ABC_SUBSCRIBER.CREATE_DATE%type default null,
    i_create_user_id           in       ABC_SUBSCRIBER.CREATE_USER_ID%type default null,    
    o_subscriber_id            out      ABC_SUBSCRIBER.SUBSCRIBER_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure inserts a new publisher into *
  *  the SUBSCRIBER table and returns the        *
  *  SUBSCRIBER_ID for the newly created         *
  *  publisher.                                  *
  ***********************************************/ 
  select SUBSCRIBER_ID_SEQ.nextval into o_subscriber_id from dual;
  insert into ABC_SUBSCRIBER (SUBSCRIBER_ID,
                             PUBLISHER_ID,
                             SUBSCRIBER_SYSTEM_ID,
                             SUBSCRIBER_NAME, 
                             SUBSCRIBER_DESCRIPTION,
                             ACTIVE_INDICATOR,
                             CREATE_DATE,
                             CREATE_USER_ID,
                             LAST_MOD_DATE,
                             LAST_MOD_USER_ID)
    values(o_subscriber_id,
           i_publisher_id,
           i_sub_system_id,
           i_subscriber_name,
           i_subscriber_description,
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
  end sp_add_subscriber;

  procedure sp_update_subscriber(
    i_subscriber_id           in       ABC_SUBSCRIBER.SUBSCRIBER_ID%type,
    i_publisher_id            in       ABC_SUBSCRIBER.PUBLISHER_ID%type,
    i_sub_system_id           in       ABC_SUBSCRIBER.SUBSCRIBER_SYSTEM_ID%type,
    i_subscriber_name         in       ABC_SUBSCRIBER.SUBSCRIBER_NAME%type,
    i_subscriber_description  in       ABC_SUBSCRIBER.SUBSCRIBER_DESCRIPTION%type default null,
    i_active_indicator        in       ABC_SUBSCRIBER.ACTIVE_INDICATOR%type default 'Y',
    i_update_date             in       ABC_SUBSCRIBER.LAST_MOD_DATE%type default null,
    i_update_user_id          in       ABC_SUBSCRIBER.LAST_MOD_USER_ID%type default null   
  )
  is
  begin
  /***********************************************
  *  This procedure updates an existing          *
  *  publisher in the SUBSCRIBER table.           *
  ***********************************************/
  update ABC_SUBSCRIBER 
  set PUBLISHER_ID = i_publisher_id,
      SUBSCRIBER_SYSTEM_ID = i_sub_system_id,
      SUBSCRIBER_NAME = i_subscriber_name, 
      SUBSCRIBER_DESCRIPTION = i_subscriber_description,
      ACTIVE_INDICATOR = DECODE(i_active_indicator,NULL,'Y', i_active_indicator),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where SUBSCRIBER_ID = i_subscriber_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_subid_notfound;
  end if;
  commit;
  exception
    when exp_subid_notfound then 
      rollback;
      raise_application_error(-20105, 'Subscriber ' || i_subscriber_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_update_subscriber;

  procedure  sp_delete_subscriber(
    i_subscriber_id     in       ABC_SUBSCRIBER.SUBSCRIBER_ID%type,
    i_update_date       in       ABC_SUBSCRIBER.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_SUBSCRIBER.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure deletes an existing          *
  *  subscriber in the SUBSCRIBER table by       *
  *  setting the DELETE_FLAG = Y.                *
  ***********************************************/ 
  update ABC_SUBSCRIBER
  set LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id),
      DELETE_FLAG = 'Y'
  where SUBSCRIBER_ID = i_subscriber_id;
  if sql%rowcount = 0 then raise exp_subid_notfound;
  end if;
  commit;
  exception
    when exp_subid_notfound then 
      rollback;
      raise_application_error(-20105, 'Subscriber ' || i_subscriber_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_delete_subscriber;

  procedure sp_start_subscription(
    i_publisher_status_id     in       ABC_SUBSCRIPTION_STATUS.PUBLISHER_STATUS_ID%type,
    i_subscriber_id           in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_ID%type,
    i_job_execution_id        in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_JOB_EXECUTION_ID%type,
    i_subscription_status_id  in       ABC_SUBSCRIPTION_STATUS.PUB_SUB_STATUS_ID%type default null,
    i_create_date             in       ABC_SUBSCRIPTION_STATUS.CREATE_DATE%type default null,
    i_create_user_id          in       ABC_SUBSCRIPTION_STATUS.CREATE_USER_ID%type default null,
    o_subscriber_status_id    out      ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_STATUS_ID%type
  )
  is
  begin
 /***********************************************
  *  This procedure starts a subscription by    *
  *  creating a new record in                   *
  *  SUBSCRIBER_EXECUTION and sets the execution* 
  *  status to active.  Returns the             *
  *  SUBSCRIBER_STATUS_ID.                      *
  ***********************************************/ 
  select SUBSCRIBER_STATUS_ID_SEQ.nextval into o_subscriber_status_id from dual;
  insert into ABC_SUBSCRIPTION_STATUS (SUBSCRIBER_STATUS_ID,
                                       PUBLISHER_STATUS_ID,
                                       SUBSCRIBER_ID,
                                       SUBSCRIBER_JOB_EXECUTION_ID,
                                       PUB_SUB_STATUS_ID,
                                       CREATE_DATE,
                                       CREATE_USER_ID,
                                       LAST_MOD_DATE,
                                       LAST_MOD_USER_ID)
    values(o_subscriber_status_id,
           i_publisher_status_id,
           i_subscriber_id,
           i_job_execution_id,
           cPubSub_Active, -- default subscription status 'Active'
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_start_subscription;

  procedure sp_set_subscription_status(
    i_subscriber_status_id    in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_STATUS_ID%type,
    i_subscription_status_id  in       ABC_SUBSCRIPTION_STATUS.PUB_SUB_STATUS_ID%type,
    i_update_date             in       ABC_SUBSCRIPTION_STATUS.LAST_MOD_DATE%type default null,
    i_update_user_id          in       ABC_SUBSCRIPTION_STATUS.LAST_MOD_USER_ID%type default null
  )
  is
  begin
  /***********************************************
  *  This procedure updates the current status   *
  *  of a publication by setting the             *
  *  PUB_SUB_ID for the given                    *
  *  SUBSCRIBER_STATUS_ID.                     *
  ***********************************************/
  update ABC_SUBSCRIPTION_STATUS 
  set PUB_SUB_STATUS_ID = i_subscription_status_id,
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where SUBSCRIBER_STATUS_ID = i_subscriber_status_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_subscriptionid_notfound;
  end if;
  commit;
  exception
    when exp_subscriptionid_notfound then 
      rollback;
      raise_application_error(-20104, 'Subscription ' || i_subscriber_status_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_set_subscription_status;

  procedure sp_set_subscription_statistics(
    i_subscriber_status_id  in       ABC_PUB_SUB_STATISTICS.PUB_SUB_STATUS_ID%type,
    i_rows_read              in       ABC_PUB_SUB_STATISTICS.ROWS_READ%type default null,
    i_rows_consumed          in       ABC_PUB_SUB_STATISTICS.ROWS_WRITTEN%type default null,
    i_rows_rejected          in       ABC_PUB_SUB_STATISTICS.ROWS_REJECTED%type default null,
    i_data_volume_read       in       ABC_PUB_SUB_STATISTICS.DATA_VOLUME_READ%type default null,
    i_data_volume_consumed   in       ABC_PUB_SUB_STATISTICS.DATA_VOLUME_WRITTEN%type default null,
    i_create_date            in       ABC_PUB_SUB_STATISTICS.CREATE_DATE%type default null,
    i_create_user_id         in       ABC_PUB_SUB_STATISTICS.CREATE_USER_ID%type default null,
    o_sub_statistics_id      out      ABC_PUB_SUB_STATISTICS.PUB_SUB_STATS_ID%type
  )
  is
  begin
  /***********************************************
  *  This procedure sets the load statistics     *
  *  for the job task run.                       *
  *  Data volume is in KB.                       *
  ***********************************************/ 
  select PUB_SUB_STATS_ID_SEQ.nextval into o_sub_statistics_id from dual;
  insert into ABC_PUB_SUB_STATISTICS (PUB_SUB_STATS_ID,
                                      PUB_SUB_TYPE,
                                      PUB_SUB_STATUS_ID,
                                      ROWS_READ,
                                      ROWS_WRITTEN,
                                      ROWS_REJECTED,
                                      DATA_VOLUME_READ,
                                      DATA_VOLUME_WRITTEN,
                                      CREATE_DATE,
                                      CREATE_USER_ID,
                                      LAST_MOD_DATE,
                                      LAST_MOD_USER_ID)
    values(o_sub_statistics_id,
           cSub_Type,
           i_subscriber_status_id,
           i_rows_read,
           i_rows_consumed,
           i_rows_rejected,
           i_data_volume_read,
           i_data_volume_consumed,
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id),
           DECODE(i_create_date,NULL, SYSDATE, i_create_date),
           DECODE(i_create_user_id, NULL, USER, i_create_user_id));
  commit;
  exception
    when others then 
      rollback;
      raise;
  end sp_set_subscription_statistics;

  procedure sp_set_subscription_consumed(
    i_subscriber_status_id    in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_STATUS_ID%type,
    i_subscription_status_id  in       ABC_SUBSCRIPTION_STATUS.PUB_SUB_STATUS_ID%type default null,
    i_subscription_date       in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBE_DATE%type default null,
    i_update_date             in       ABC_SUBSCRIPTION_STATUS.LAST_MOD_DATE%type default null,
    i_update_user_id          in       ABC_SUBSCRIPTION_STATUS.LAST_MOD_USER_ID%type default null
  )
  is 
  begin
  /***********************************************
  *  This procedure sets the data set as         *
  *  available for consumption.                  *
  ***********************************************/ 
  update ABC_SUBSCRIPTION_STATUS 
  set PUB_SUB_STATUS_ID = DECODE(i_subscription_status_id, NULL, cPubSub_Consumed, i_subscription_status_id),
      SUBSCRIBE_DATE = DECODE(i_subscription_date, NULL, SYSDATE, i_subscription_date),
      LAST_MOD_DATE = DECODE(i_update_date,NULL, SYSDATE, i_update_date),
      LAST_MOD_USER_ID = DECODE(i_update_user_id, NULL, USER, i_update_user_id)
  where SUBSCRIBER_STATUS_ID = i_subscriber_status_id
        and
        DELETE_FLAG != 'Y';
  if sql%rowcount = 0 then raise exp_subscriptionid_notfound;
  end if;
  commit;
  exception
    when exp_subscriptionid_notfound then 
      rollback;
      raise_application_error(-20104, 'Subscription ' || i_subscriber_status_id || ' not found');
    when others then 
      rollback;
      raise;
  end sp_set_subscription_consumed;
END spckg_DCOE_ABC_PUBSUB;



-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;
