``` go
subQuery := m.Table("testphase").Select("test_run, MAX(created_at) created_at").Where("test_run in (?)", testrun_ids).Group("test_run")

err := m.Table("testphase as t").Joins("JOIN (?) as sub ON sub.test_run = t.test_run", subQuery).Select("id, t.test_run as test_run").Where("t.test_run = sub.test_run AND t.created_at = sub.created_at").Find(&testrun_testphase).Error
```