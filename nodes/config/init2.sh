# Start supervisor
mkdir -p /var/log/supervisor
supervisord -c /etc/supervisor/supervisord.conf
tail -f /dev/null