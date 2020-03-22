-- Example query on 18c.
-- Depency to Application Express package apex_web_service
select
  from_name
  ,from_email
  ,subject
  ,email_body
  ,apex_web_service.clobbase642blob(file_content) as file_content
from mail_inbox,
json_table( mail_json,'$'
  columns(
    subject,
    from_name path '$.from.name',
    from_email path '$.from.email',
    nested "parts"[*]
    columns (
      content_type,
      email_body path '$.content'
    )
  )
) jt1,
json_table( mail_json,'$'
  columns(
    nested "attachments"[*]
    columns (
      file_content path '$.content'
    )
  )
) jt2
where 1 = 1
and jt1.content_type = 'text/plain'
;
