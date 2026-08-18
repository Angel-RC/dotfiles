-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Purge trash items older than 30 days on every session start.
o.exec_on_start("trash-empty -f 30")
