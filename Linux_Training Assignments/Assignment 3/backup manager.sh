
#!/bin/bash

if [ $# -ne 3 ];then
echo "Please provide all the required inputs: <Source directory> <Backup directory> <File extension>"
exit 1
fi

source_dir="$1"
backup_dir="$2"
file_ext="$3"

						

echo "<Source Directory>:$source_dir"		#Confirming the user with the paths
echo "<Destination Directory>:$backup_dir"
echo "<File extension>:$file_ext"

if [ ! -d "$source_dir" ];then
echo "Input Source Directory properly"
exit 1

elif [ ! -d "$backup_dir" ];then
echo "Input backup directory properly"
exit 1

else
echo "Both the directories are valid"
fi

 
							# 2)Globbing to find the files with the given extension
if ! cd "$source_dir";then
	echo "Check the Source directory path"		#exit the code when source directory is not found
	exit 1
fi


files=(*"$file_ext")					#4)Array operations
if [ ! -e "${files[0]}" ];then
echo "No matching files found!"				#exit the code when no such files are found
exit 1
fi

backup_count=0
total_size=0

if [ ! -d "$backup_dir" ];then
mkdir -p "$backup_dir" || { echo "Failed to create backup directory"; exit 1;}
fi

for check_file in "${files[@]}"; do							#5)conditional execution
	backup_file="$backup_dir/$(basename "$check_file")"


	if [ ! -e "$backup_file" ] || [ "$check_file" -nt "$backup_file" ];then		
		cp "$check_file" "$backup_file"
		((backup_count++))
		((total_size+=$(stat -c %s "$check_file")))
	fi
done

export BACKUP_COUNT=$backup_count				#3)Export statement
report_file_path="$backup_dir"/backup_report.log		#4)Output Report
echo "Total files processed=$BACKUP_COUNT" > "$report_file_path"
echo "Total size of files backed up=$total_size" >> "$report_file_path"
echo "The path to the backup directory=$backup_dir" >> "$report_file_path"

