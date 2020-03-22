declare
  l_roles     owa.vc_arr;
  l_modules   owa.vc_arr;
  l_patterns  owa.vc_arr;

begin

  ords.define_module(
      p_module_name    => 'ords.rest.module.mail',
      p_base_path      => '/mail/',
      p_items_per_page => 25,
      p_status         => 'PUBLISHED',
      p_comments       => null);

  ords.define_template(
      p_module_name    => 'ords.rest.module.mail',
      p_pattern        => 'receive',
      p_priority       => 0,
      p_etag_type      => 'HASH',
      p_etag_query     => null,
      p_comments       => null);

  ords.define_handler(
      p_module_name    => 'ords.rest.module.mail',
      p_pattern        => 'receive',
      p_method         => 'POST',
      p_source_type    => 'plsql/block',
      p_mimes_allowed  => '',
      p_comments       => null,
      p_source         =>
'begin
  insert into mail_inbox(mail_json) values(:body_text);
  :status := 204;
exception when others then
  :status := 400;
end;');

  ords.define_parameter(
      p_module_name        => 'ords.rest.module.mail',
      p_pattern            => 'receive',
      p_method             => 'POST',
      p_name               => 'X-ORDS-STATUS-CODE',
      p_bind_variable_name => 'status',
      p_source_type        => 'HEADER',
      p_param_type         => 'STRING',
      p_access_method      => 'OUT',
      p_comments           => null);


  ords.create_role(p_role_name => 'client.role.mail');

  l_roles(1) := 'client.role.mail';
  l_modules(1) := 'ords.rest.module.mail';

  ords.define_privilege(
      p_privilege_name => 'client.privilege.mail',
      p_roles          => l_roles,
      p_patterns       => l_patterns,
      p_modules        => l_modules,
      p_label          => 'Mail Client',
      p_description    => '',
      p_comments       => null);

  l_roles.delete;
  l_modules.delete;
  l_patterns.delete;

commit;

end;
/
