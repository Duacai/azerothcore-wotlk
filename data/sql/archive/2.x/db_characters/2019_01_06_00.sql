-- DB update 2018_12_23_00 -> 2019_01_06_00
DROP PROCEDURE IF EXISTS `updateDb`;
DELIMITER //
CREATE PROCEDURE updateDb ()
proc:BEGIN DECLARE OK VARCHAR(100) DEFAULT 'FALSE';
SELECT COUNT(*) INTO @COLEXISTS
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'version_db_characters' AND COLUMN_NAME = '2018_12_23_00';
IF @COLEXISTS = 0 THEN LEAVE proc; END IF;
START TRANSACTION;
ALTER TABLE version_db_characters CHANGE COLUMN 2018_12_23_00 2019_01_06_00 bit;
SELECT sql_rev INTO OK FROM version_db_characters WHERE sql_rev = '1546637940772193620'; IF OK <> 'FALSE' THEN LEAVE proc; END IF;
--
-- START UPDATING QUERIES
--

INSERT INTO version_db_characters (`sql_rev`) VALUES ('1546637940772193620');

DROP TABLE IF EXISTS `quest_tracker`;
CREATE TABLE `quest_tracker` (
    `id` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0',
    `character_guid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `quest_accept_time` DATETIME NOT NULL,
    `quest_complete_time` DATETIME DEFAULT NULL,
    `quest_abandon_time` DATETIME DEFAULT NULL,
    `completed_by_gm` BOOL NOT NULL DEFAULT '0',
    `core_hash` VARCHAR(120) NOT NULL DEFAULT '0',
    `core_revision` VARCHAR(120) NOT NULL DEFAULT '0'
)
ENGINE=InnoDB;

--
-- END UPDATING QUERIES
--
COMMIT;
END //
DELIMITER ;
CALL updateDb();
DROP PROCEDURE IF EXISTS `updateDb`;
