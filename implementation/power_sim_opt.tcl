open_saif $::env(SAIF_FILE).saif
log_saif [get_objects -r *]
run 25us
close_saif
current_time
quit