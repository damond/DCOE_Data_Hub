/*********************************************** 
*            spckg_DCOE_ABC_PUBSUB             *
*   Author:  Doug Damon                        *
*   Date:  5/16/2013                           *
*  This package defines the PUB/SUB interfaces *
*  tothe DCOE Data Hub ABC data model.         *
***********************************************/ 

CREATE OR REPLACE PACKAGE spckg_DCOE_ABC_PUBSUB
as
-- Declare Types --
  cPubSub_Active     CONSTANT INTEGER :=  1;
  cPubSub_Published  CONSTANT INTEGER := 10;
  cPubSub_Consumed   CONSTANT INTEGER := 20;
  cPub_Type          CONSTANT VARCHAR2(3) := 'PUB';
  cSub_Type          CONSTANT VARCHAR2(3) := 'SUB';

  exp_pubid_notfound           EXCEPTION;
  exp_subid_notfound           EXCEPTION;
  exp_publicationid_notfound   EXCEPTION; 
  exp_subscriptionid_notfound  EXCEPTION;

  /***********************************************
  *  This procedure inserts a new publisher into *
  *  the PUBLISHER table and returns the         *
  *  PUBLISHER_ID for the newly created          *
  *  publisher.                                  *
  ***********************************************/ 
  procedure sp_add_publisher(
    i_data_entity_id          in       ABC_PUBLISHER.DATA_ENTITY_ID%type,
    i_pub_system_id           in       ABC_PUBLISHER.PUBLISHER_SYSTEM_ID%type,
    i_publisher_name          in       ABC_PUBLISHER.PUBLISHER_NAME%type,
    i_publisher_description   in       ABC_PUBLISHER.PUBLISHER_DESCRIPTION%type default null,
    i_active_indicator        in       ABC_PUBLISHER.ACTIVE_INDICATOR%type default 'Y',
    i_create_date             in       ABC_PUBLISHER.CREATE_DATE%type default null,
    i_create_user_id          in       ABC_PUBLISHER.CREATE_USER_ID%type default null,    
    o_publisher_id            out      ABC_PUBLISHER.PUBLISHER_ID%type
  );

  /***********************************************
  *  This procedure returns job details for a    *
  *  given PUBLISHER_ID.                         *
  ***********************************************/ 
/*  procedure sp_get_publisher(
    io_publisher_id          in out    ABC_PUBLISHER.PUBLISHER_ID%type    
    o_data_entity_id         out       ABC_PUBLISHER.DATA_ENTITY_ID%type,
    o_system_id              out       ABC_PUBLISHER.PUBLISHER_SYSTEM_ID%type,
    o_publisher_name         out       ABC_PUBLISHER.PUBLISHER_NAME%type,
    o_publisher_description  out       ABC_PUBLISHER.PUBLISHER_DESCRIPTION%type,
    o_source_sytem_id        out       ABC_PUBLISHER.SOURCE_SYSTEM_ID%type,
    o_source_sys_name        out       ABC_PUBLISHER.SYSTEM_NAME%type,
    o_create_date            out       ABC_PUBLISHER.CREATE_DATE%type,
    o_create_user_id         out       ABC_PUBLISHER.CREATE_USER_ID%type,    
    o_update_date            out       ABC_PUBLISHER.LAST_MOD_DATE%type,
    o_update_user_id         out       ABC_PUBLISHER.LAST_MOD_USER_ID%type
  ); 
 */

  /***********************************************
  *  This procedure updates an existing          *
  *  publisher in the PUBLISHER table.           *
  ***********************************************/ 
  procedure sp_update_publisher(
    i_publisher_id           in       ABC_PUBLISHER.PUBLISHER_ID%type,
    i_data_entity_id         in       ABC_PUBLISHER.DATA_ENTITY_ID%type,
    i_pub_system_id          in       ABC_PUBLISHER.PUBLISHER_SYSTEM_ID%type,
    i_publisher_name         in       ABC_PUBLISHER.PUBLISHER_NAME%type,
    i_publisher_description  in       ABC_PUBLISHER.PUBLISHER_DESCRIPTION%type default null,
    i_active_indicator       in       ABC_PUBLISHER.ACTIVE_INDICATOR%type default 'Y',
    i_update_date            in       ABC_PUBLISHER.LAST_MOD_DATE%type default null,
    i_update_user_id         in       ABC_PUBLISHER.LAST_MOD_USER_ID%type default null     
  );

  /***********************************************
  *  This procedure deletes an existing          *
  *  publisher in the PUBLISHER table by setting * 
  *  the DELETE_FLAG = Y.                        *
  ***********************************************/ 
  procedure sp_delete_publisher(
    i_publisher_id      in       ABC_PUBLISHER.PUBLISHER_ID%type,
    i_update_date       in       ABC_PUBLISHER.LAST_MOD_DATE%type default null,
    i_update_user_id    in       ABC_PUBLISHER.LAST_MOD_USER_ID%type default null     
  );

 /***********************************************
  *  This procedure starts a publication by     *
  *  creating a new record in                   *
  *  PUBLICATION_STATUS and sets the execution  * 
  *  status to active.  Returns the             *
  *  PUBLISHER_STATUS_ID.                       *
  ***********************************************/ 
  procedure sp_start_publication(
    i_job_execution_id      in       ABC_PUBLICATION_STATUS.JOB_EXECUTION_ID%type,
    i_publisher_id          in       ABC_PUBLICATION_STATUS.PUBLISHER_ID%type,
    i_create_date           in       ABC_PUBLICATION_STATUS.CREATE_DATE%type default null,
    i_create_user_id        in       ABC_PUBLICATION_STATUS.CREATE_USER_ID%type default null,
    o_publisher_status_id   out      ABC_PUBLICATION_STATUS.PUBLISHER_STATUS_ID%type
  );

  /***********************************************
  *  This procedure updates the current status   *
  *  of a publication by setting the             *
  *  PUB_SUB_ID for the given                    *
  *  PUBLISHER_STATUS_ID.                     *
  ***********************************************/ 
  procedure sp_set_publication_status(
    i_publisher_status_id    in       ABC_PUBLICATION_STATUS.PUBLISHER_STATUS_ID%type,
    i_publication_status_id  in       ABC_PUBLICATION_STATUS.PUB_SUB_STATUS_ID%type,
    i_update_date            in       ABC_PUBLICATION_STATUS.LAST_MOD_DATE%type default null,
    i_update_user_id         in       ABC_PUBLICATION_STATUS.LAST_MOD_USER_ID%type default null
  );

  /***********************************************
  *  This procedure sets the load statistics     *
  *  for the job task run.                       *
  *  Data volume is in KB.                       *
  ***********************************************/ 
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
  );

  /***********************************************
  *  This procedure sets the data set as         *
  *  available for consumption.                  *
  ***********************************************/ 
  procedure sp_set_publication_published(
    i_publisher_status_id    in       ABC_PUBLICATION_STATUS.PUBLISHER_STATUS_ID%type,
    i_publication_status_id  in       ABC_PUBLICATION_STATUS.PUB_SUB_STATUS_ID%type default null,
    i_publication_date       in       ABC_PUBLICATION_STATUS.PUBLISH_DATE%type default null,
    i_update_date            in       ABC_PUBLICATION_STATUS.LAST_MOD_DATE%type default null,
    i_update_user_id         in       ABC_PUBLICATION_STATUS.LAST_MOD_USER_ID%type default null
  );

  /***********************************************
  *  This procedure inserts a new publisher into *
  *  the SUBSCRIBER table and returns the        *
  *  SUBSCRIBER_ID for the newly created         *
  *  publisher.                                  *
  ***********************************************/ 
  procedure sp_add_subscriber(
    i_publisher_id             in       ABC_SUBSCRIBER.PUBLISHER_ID%type,
    i_sub_system_id            in       ABC_SUBSCRIBER.SUBSCRIBER_SYSTEM_ID%type,
    i_subscriber_name          in       ABC_SUBSCRIBER.SUBSCRIBER_NAME%type,
    i_subscriber_description   in       ABC_SUBSCRIBER.SUBSCRIBER_DESCRIPTION%type default null,
    i_active_indicator         in       ABC_SUBSCRIBER.ACTIVE_INDICATOR%type default 'Y',
    i_create_date              in       ABC_SUBSCRIBER.CREATE_DATE%type default null,
    i_create_user_id           in       ABC_SUBSCRIBER.CREATE_USER_ID%type default null,    
    o_subscriber_id            out      ABC_SUBSCRIBER.SUBSCRIBER_ID%type
  );

  /***********************************************
  *  This procedure returns job details for a    *
  *  given SUBSCRIBER_ID.                         *
  ***********************************************/ 
/*  procedure sp_get_publisher(
    io_subscriber_id          in out    ABC_SUBSCRIBER.SUBSCRIBER_ID%type    
    o_data_entity_id          out       ABC_SUBSCRIBER.DATA_ENTITY_ID%type,
    o_system_id               out       ABC_SUBSCRIBER.SUBSCRIBER_SYSTEM_ID%type,
    o_subscriber_name         out       ABC_SUBSCRIBER.SUBSCRIBER_NAME%type,
    o_subscriber_description  out       ABC_SUBSCRIBER.SUBSCRIBER_DESCRIPTION%type,
    o_source_sytem_id         out       ABC_SUBSCRIBER.SOURCE_SYSTEM_ID%type,
    o_source_sys_name         out       ABC_SUBSCRIBER.SYSTEM_NAME%type,
    o_create_date             out       ABC_SUBSCRIBER.CREATE_DATE%type,
    o_create_user_id          out       ABC_SUBSCRIBER.CREATE_USER_ID%type,    
    o_update_date             out       ABC_SUBSCRIBER.LAST_MOD_DATE%type,
    o_update_user_id          out       ABC_SUBSCRIBER.LAST_MOD_USER_ID%type
  ); 
 */

  /***********************************************
  *  This procedure updates an existing          *
  *  publisher in the SUBSCRIBER table.           *
  ***********************************************/ 
  procedure sp_update_subscriber(
    i_subscriber_id           in       ABC_SUBSCRIBER.SUBSCRIBER_ID%type,
    i_publisher_id            in       ABC_SUBSCRIBER.PUBLISHER_ID%type,
    i_sub_system_id           in       ABC_SUBSCRIBER.SUBSCRIBER_SYSTEM_ID%type,
    i_subscriber_name         in       ABC_SUBSCRIBER.SUBSCRIBER_NAME%type,
    i_subscriber_description  in       ABC_SUBSCRIBER.SUBSCRIBER_DESCRIPTION%type default null,
    i_active_indicator        in       ABC_SUBSCRIBER.ACTIVE_INDICATOR%type default 'Y',
    i_update_date             in       ABC_SUBSCRIBER.LAST_MOD_DATE%type default null,
    i_update_user_id          in       ABC_SUBSCRIBER.LAST_MOD_USER_ID%type default null     
  );

  /***********************************************
  *  This procedure deletes an existing          *
  *  subscriber in the SUBSCRIBER table by       *
  *  setting the DELETE_FLAG = Y.                *
  ***********************************************/ 
  procedure sp_delete_subscriber(
    i_subscriber_id      in       ABC_SUBSCRIBER.SUBSCRIBER_ID%type,
    i_update_date        in       ABC_SUBSCRIBER.LAST_MOD_DATE%type default null,
    i_update_user_id     in       ABC_SUBSCRIBER.LAST_MOD_USER_ID%type default null     
  );

 /***********************************************
  *  This procedure starts a subscription by    *
  *  creating a new record in                   *
  *  SUBSCRIBER_EXECUTION and sets the execution* 
  *  status to active.  Returns the             *
  *  SUBSCRIBER_STATUS_ID.                      *
  ***********************************************/ 
  procedure sp_start_subscription(
    i_publisher_status_id     in       ABC_SUBSCRIPTION_STATUS.PUBLISHER_STATUS_ID%type,
    i_subscriber_id           in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_ID%type,
    i_job_execution_id        in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_JOB_EXECUTION_ID%type,
    i_subscription_status_id  in       ABC_SUBSCRIPTION_STATUS.PUB_SUB_STATUS_ID%type default null,
    i_create_date             in       ABC_SUBSCRIPTION_STATUS.CREATE_DATE%type default null,
    i_create_user_id          in       ABC_SUBSCRIPTION_STATUS.CREATE_USER_ID%type default null,
    o_subscriber_status_id    out      ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_STATUS_ID%type
  );

  /***********************************************
  *  This procedure updates the current status   *
  *  of a subscription by setting the            *
  *  PUB_SUB_ID for the given                    *
  *  SUBSCRIBER_STATUS_ID.                       *
  ***********************************************/ 
  procedure sp_set_subscription_status(
    i_subscriber_status_id    in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_STATUS_ID%type,
    i_subscription_status_id  in       ABC_SUBSCRIPTION_STATUS.PUB_SUB_STATUS_ID%type,
    i_update_date             in       ABC_SUBSCRIPTION_STATUS.LAST_MOD_DATE%type default null,
    i_update_user_id          in       ABC_SUBSCRIPTION_STATUS.LAST_MOD_USER_ID%type default null
  );

  /***********************************************
  *  This procedure sets the load statistics     *
  *  for the job task run.                       *
  *  Data volume is in KB.                       *
  ***********************************************/ 
  procedure sp_set_subscription_statistics(
    i_subscriber_status_id   in       ABC_PUB_SUB_STATISTICS.PUB_SUB_STATUS_ID%type,
    i_rows_read              in       ABC_PUB_SUB_STATISTICS.ROWS_READ%type default null,
    i_rows_consumed          in       ABC_PUB_SUB_STATISTICS.ROWS_WRITTEN%type default null,
    i_rows_rejected          in       ABC_PUB_SUB_STATISTICS.ROWS_REJECTED%type default null,
    i_data_volume_read       in       ABC_PUB_SUB_STATISTICS.DATA_VOLUME_READ%type default null,
    i_data_volume_consumed   in       ABC_PUB_SUB_STATISTICS.DATA_VOLUME_WRITTEN%type default null,
    i_create_date            in       ABC_PUB_SUB_STATISTICS.CREATE_DATE%type default null,
    i_create_user_id         in       ABC_PUB_SUB_STATISTICS.CREATE_USER_ID%type default null,
    o_sub_statistics_id      out      ABC_PUB_SUB_STATISTICS.PUB_SUB_STATS_ID%type
  );

  /***********************************************
  *  This procedure sets the data set as         *
  *  consumed.                                   *
  ***********************************************/ 
  procedure sp_set_subscription_consumed(
    i_subscriber_status_id    in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBER_STATUS_ID%type,
    i_subscription_status_id  in       ABC_SUBSCRIPTION_STATUS.PUB_SUB_STATUS_ID%type default null,
    i_subscription_date       in       ABC_SUBSCRIPTION_STATUS.SUBSCRIBE_DATE%type default null,
    i_update_date             in       ABC_SUBSCRIPTION_STATUS.LAST_MOD_DATE%type default null,
    i_update_user_id          in       ABC_SUBSCRIPTION_STATUS.LAST_MOD_USER_ID%type default null
  );

end spckg_DCOE_ABC_PUBSUB;


-- END PL/SQL BLOCK (do not remove this line) ----------------------------------;


