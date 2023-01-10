#!/system/bin/sh
# Detach script - Disable Play store updates for YouTube ReVanced Extended

export PATH="${0%/*}/bin:$PATH"

. "${0%/*}/utils.sh"
# Expansion
LOG="${0%/*}/detach.log"
PS=com.android.vending
DB=/data/data/$PS/databases
LDB=$DB/library.db
LADB=$DB/localappstate.db
GET_LDB=$(sqlite3 $LDB "SELECT doc_id,doc_type FROM ownership" | grep $PK | head -n 1 | grep -o 25)

# Main script
if [ "$GET_LDB" != "25" ]; then
	# Disable Play store
	cmd appops set --uid $PS GET_USAGE_STATS ignore
	
	# Update database
	sqlite3 $LDB "UPDATE ownership SET doc_type = '25' WHERE doc_id = '$PK'";
	sqlite3 $LADB "UPDATE appstate SET auto_update = '2' WHERE package_name = '$PACKAGE_NAME'";
	
	# Remove cache
	rm -rf /data/data/$PS/cache/*

	# Log
	echo "$(date) - YouTube ReVanced Extended successfully detached from play store" >> $LOG
fi
