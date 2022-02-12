ALTER TABLE test_run CHANGE name name VARCHAR(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci NOT NULL;

mysql -uusername -ppaswsord --default-character-set=utf8 dbname > outputfile
mysql -uuser -ppassword --default-character-set=utf8 dbname < inputfile
