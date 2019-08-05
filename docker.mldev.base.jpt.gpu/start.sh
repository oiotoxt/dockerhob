#!/bin/bash

echo "[start.sh] executed"

if [ -z "${PUID}" -o -z "${PGID}" ]; then
    exec /bin/bash
else
    if [ "${PUID}" -eq 0 -o "${PGID}" -eq 0 ]; then
        echo "[start.sh] Nothing to do here." ; exit 0
    fi
fi

PGID=${PGID:-5555}
PUID=${PUID:-5555}
echo "PUID=${PUID}"
echo "PGID=${PGID}"

groupmod -o -g "$PGID" coder
usermod -o -u "$PUID" coder
chown -R ${PUID}:${PGID} /home/coder

su - coder -c "ssh-keygen -q -t rsa -b 4096 -f ~/.ssh/id_rsa -C coder[${PUID}-${PGID}]@$(hostname) -N ''"
echo "[start.sh] ssh-key generated."

#-------------------------------------------------------------------------------
# Handle SIG TERM
WORKER_PID=''

handle_sig_term(){
    # echo "[start.sh] SIGTERM received."
    # kill -TERM $WORKER_PID
    # wait $WORKER_PID

    echo "[start.sh] Stop jupyter notebook."
    jupyter notebook stop 8888
}

trap 'handle_sig_term' TERM
#-------------------------------------------------------------------------------
echo "WORKSPACE=${WORKSPACE}"
echo "NOTEBOOKAPP_PASSWORD=${NOTEBOOKAPP_PASSWORD}"

su - coder -c "jupyter notebook --ip 0.0.0.0 --no-browser --allow-root --notebook-dir=${WORKSPACE} --NotebookApp.password=${NOTEBOOKAPP_PASSWORD}" & WORKER_PID=$!
wait $WORKER_PID
