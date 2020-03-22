declare
  l_client_id varchar2(255);
  l_client_secret varchar2(255);
  l_client_name varchar2(255) := 'client.mail';
begin

--  oauth.delete_client(
--    p_name => l_client_name
--  );

  oauth.create_client(
    p_name            => l_client_name,
    p_grant_type      => 'client_credentials',
    p_owner           => '',
    p_description     => 'Email client to send emails to database',
    p_support_email   => 'nobody@example.com',
    p_privilege_names => 'client.privilege.mail'
  );

  oauth.grant_client_role(
    p_client_name => l_client_name,
    p_role_name   => 'client.role.mail'
  );

  commit;

  select client_id
    ,client_secret
  into l_client_id, l_client_secret
  from user_ords_clients
  where 1 = 1
  and name = l_client_name
  ;

  dbms_output.put_line( 'Client Id: ' || l_client_id );
  dbms_output.put_line( 'Client Secret: ' || l_client_secret );

end;
/
