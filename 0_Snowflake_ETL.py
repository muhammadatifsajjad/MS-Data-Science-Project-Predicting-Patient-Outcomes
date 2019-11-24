import os
import snowflake.connector as sf

os.chdir(r'C:\Users\Muhammad Atif\Google Drive\UniMelb - Masters Of Data Science - 2018-2019\Semester 1 2019\Data Science Project Part 1 - MAST90106_2019_SM1\Project\Code')

def execute_scripts_from_file(filename, con):
    # Open and read the file as a single buffer
    fd = open(filename, 'r')
    sql_file = fd.read()
    fd.close()
    
    # all SQL commands (split on ';')
    sql_commands = sql_file.split(';')
    
    # Execute every command from the input file
    for command in sql_commands:
        try:
            con.cursor().execute(command)
        except Exception as e:
            print(e)

# open connection with database
# Snowflake
sf_conn = sf.connect(user='********', password='********', \
                     account='********')
   
try:   
    # read from Snowflake database
    sql_path = 'ETL\ND_Snowflake_ETL.sql'
    execute_scripts_from_file(sql_path, sf_conn)
    
except Exception as e:
    print(e)
    
finally:
    sf_conn.close()