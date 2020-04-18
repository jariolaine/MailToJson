-- Example query on 18c.
-- Depency to Application Express package apex_web_service
select t1.id
  ,t1.created
  ,j1.from_header
  ,j1.subject
  ,j1.email_body
  ,j2.file_name
  ,j2.content_type as mime_type
  ,apex_web_service.clobbase642blob(j2.file_content) as blob_content
from mail_inbox t1,
json_table( mail_json,'$'
  columns(
    subject,
    from_header path '$.headers.from',
    nested "parts"[*]
    columns (
      content_type,
      email_body path '$.content'
    )
  )
) j1,
json_table( mail_json,'$'
  columns(
    nested "attachments"[*]
    columns (
      content_type,
      file_name path '$.filename',
      file_content path '$.content'
    )
  )
) j2
where 1 = 1
and j1.content_type = 'text/plain'
order by t1.id
;
