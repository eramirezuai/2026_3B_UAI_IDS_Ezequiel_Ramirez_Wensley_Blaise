SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- DROP DATABASE IF EXISTS [Fletex];
-- GO

CREATE DATABASE [Fletex];
GO

USE [Fletex];
GO

-- ============================================================
-- PARTE TECNICA — MODELO DE SEGURIDAD
-- ============================================================

CREATE TABLE [dbo].[user] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(100) NOT NULL,
    [password] CHAR(64) NOT NULL,
    [email] NVARCHAR(200) NOT NULL,
    CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE TABLE [dbo].[family] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [code] VARCHAR(100) NOT NULL,
    [description] NVARCHAR(500) NOT NULL,
    CONSTRAINT [PK_family] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE TABLE [dbo].[patent] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [code] VARCHAR(100) NOT NULL,
    [description] NVARCHAR(500) NOT NULL,
    CONSTRAINT [PK_patent] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE TABLE [dbo].[family_patent] (
    [family_id] BIGINT NOT NULL,
    [patent_id] BIGINT NOT NULL,
    CONSTRAINT [PK_family_patent] PRIMARY KEY ([family_id], [patent_id]),
    CONSTRAINT [FK_family_patent_family] FOREIGN KEY ([family_id]) REFERENCES [dbo].[family] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_family_patent_patent] FOREIGN KEY ([patent_id]) REFERENCES [dbo].[patent] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [dbo].[user_family] (
    [user_id] BIGINT NOT NULL,
    [family_id] BIGINT NOT NULL,
    CONSTRAINT [PK_user_family] PRIMARY KEY ([user_id], [family_id]),
    CONSTRAINT [FK_user_family_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[user] ([id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_user_family_family] FOREIGN KEY ([family_id]) REFERENCES [dbo].[family] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [dbo].[family_family] (
    [parent_id] BIGINT NOT NULL,
    [child_id] BIGINT NOT NULL,
    CONSTRAINT [PK_family_family] PRIMARY KEY ([parent_id], [child_id]),
    CONSTRAINT [FK_family_family_parent] FOREIGN KEY ([parent_id]) REFERENCES [dbo].[family] ([id]),
    CONSTRAINT [FK_family_family_child] FOREIGN KEY ([child_id]) REFERENCES [dbo].[family] ([id])
);
GO

CREATE TABLE [dbo].[vvd] (
    [table_name] NVARCHAR(50) NOT NULL,
    [digit] CHAR(64) NOT NULL,
    CONSTRAINT [PK_vvd] PRIMARY KEY CLUSTERED ([table_name] ASC)
);
GO

CREATE TABLE [dbo].[audit] (
    [audit_id] BIGINT IDENTITY(1,1) NOT NULL,
    [previous_audit_id] BIGINT NULL,
    [next_audit_id] BIGINT NULL,
    [entity_name] NVARCHAR(100) NOT NULL,
    [entity_id] BIGINT NOT NULL,
    [snapshot] NVARCHAR(MAX) NOT NULL,
    [date] DATETIME NOT NULL,
    CONSTRAINT [PK_audit] PRIMARY KEY CLUSTERED ([audit_id] ASC)
);
GO

-- ============================================================
-- PARTE TECNICA — MULTIIDIOMA
-- ============================================================

CREATE TABLE [dbo].[language] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [code] VARCHAR(10) NOT NULL,
    [name] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_language] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE TABLE [dbo].[translation_code] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [code] VARCHAR(200) NOT NULL,
    [description] NVARCHAR(500) NULL,
    CONSTRAINT [PK_translation_code] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE TABLE [dbo].[translation_string] (
    [language_id] BIGINT NOT NULL,
    [translation_code_id] BIGINT NOT NULL,
    [value] NVARCHAR(MAX) NOT NULL,
    CONSTRAINT [PK_translation_string] PRIMARY KEY ([language_id], [translation_code_id]),
    CONSTRAINT [FK_translation_string_language] FOREIGN KEY ([language_id]) REFERENCES [dbo].[language] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_translation_string_translation_code] FOREIGN KEY ([translation_code_id]) REFERENCES [dbo].[translation_code] ([id]) ON DELETE CASCADE
);
GO

-- ============================================================
-- DOMAIN MODEL — ACTORS
-- ============================================================

-- conductor.status enum (TINYINT):
--   0 = PendingVerification | 1 = Active | 2 = Suspended | 3 = Rejected

CREATE TABLE [dbo].[client] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [user_id] BIGINT NOT NULL,
    [first_name] NVARCHAR(100) NOT NULL,
    [last_name] NVARCHAR(100) NOT NULL,
    [phone] NVARCHAR(30) NULL,
    [address] NVARCHAR(300) NULL,
    [payment_method] NVARCHAR(100) NULL,
    CONSTRAINT [PK_client] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_client_user_id] UNIQUE ([user_id]),
    CONSTRAINT [FK_client_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[user] ([id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [dbo].[conductor] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [user_id] BIGINT NOT NULL,
    [first_name] NVARCHAR(100) NOT NULL,
    [last_name] NVARCHAR(100) NOT NULL,
    [dni] NVARCHAR(20) NOT NULL,
    [phone] NVARCHAR(30) NULL,
    [operation_zone] NVARCHAR(200) NULL,
    [status] TINYINT NOT NULL CONSTRAINT [DF_conductor_status] DEFAULT 0,
    [avg_rating] DECIMAL(3,2) NULL,
    CONSTRAINT [PK_conductor] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_conductor_user_id] UNIQUE ([user_id]),
    CONSTRAINT [FK_conductor_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[user] ([id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [dbo].[vehicle] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [conductor_id] BIGINT NOT NULL,
    [brand] NVARCHAR(100) NOT NULL,
    [model] NVARCHAR(100) NOT NULL,
    [year] INT NOT NULL,
    [license_plate] NVARCHAR(20) NOT NULL,
    [cargo_capacity] DECIMAL(10,2) NOT NULL,
    [vehicle_type] NVARCHAR(50) NOT NULL,
    CONSTRAINT [PK_vehicle] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_vehicle_license_plate] UNIQUE ([license_plate]),
    CONSTRAINT [FK_vehicle_conductor] FOREIGN KEY ([conductor_id]) REFERENCES [dbo].[conductor] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [dbo].[conductor_document] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [conductor_id] BIGINT NOT NULL,
    [document_type] NVARCHAR(100) NOT NULL,
    [file_path] NVARCHAR(500) NOT NULL,
    [expiry_date] DATE NULL,
    [uploaded_at] DATETIME NOT NULL CONSTRAINT [DF_conductor_document_uploaded_at] DEFAULT GETDATE(),
    CONSTRAINT [PK_conductor_document] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_conductor_document_conductor] FOREIGN KEY ([conductor_id]) REFERENCES [dbo].[conductor] ([id]) ON DELETE CASCADE
);
GO

-- ============================================================
-- DOMAIN MODEL — TARIFFS AND SERVICE REQUESTS
-- ============================================================

CREATE TABLE [dbo].[tariff_config] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [base_fare] DECIMAL(10,2) NOT NULL,
    [cost_per_km] DECIMAL(10,4) NOT NULL,
    [effective_from] DATETIME NOT NULL,
    [effective_to] DATETIME NULL,
    CONSTRAINT [PK_tariff_config] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE TABLE [dbo].[tariff_surcharge] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [tariff_config_id] BIGINT NOT NULL,
    [surcharge_type] NVARCHAR(100) NOT NULL,
    [value] DECIMAL(10,4) NOT NULL,
    CONSTRAINT [PK_tariff_surcharge] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tariff_surcharge_tariff_config] FOREIGN KEY ([tariff_config_id]) REFERENCES [dbo].[tariff_config] ([id]) ON DELETE CASCADE
);
GO

-- service_request.status enum (TINYINT):
--   0 = Pending | 1 = Assigned | 2 = InProgress | 3 = Completed | 4 = Cancelled

CREATE TABLE [dbo].[service_request] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [client_id] BIGINT NOT NULL,
    [origin_address] NVARCHAR(300) NOT NULL,
    [destination_address] NVARCHAR(300) NOT NULL,
    [cargo_type] NVARCHAR(100) NOT NULL,
    [required_datetime] DATETIME NOT NULL,
    [vehicle_type] NVARCHAR(50) NOT NULL,
    [status] TINYINT NOT NULL CONSTRAINT [DF_service_request_status] DEFAULT 0,
    [tracking_number] NVARCHAR(50) NOT NULL,
    [created_at] DATETIME NOT NULL CONSTRAINT [DF_service_request_created_at] DEFAULT GETDATE(),
    CONSTRAINT [PK_service_request] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_service_request_tracking] UNIQUE ([tracking_number]),
    CONSTRAINT [FK_service_request_client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[client] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [dbo].[service_request_quote] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [service_request_id] BIGINT NOT NULL,
    [tariff_config_id] BIGINT NOT NULL,
    [estimated_amount] DECIMAL(10,2) NOT NULL,
    [calculated_at] DATETIME NOT NULL CONSTRAINT [DF_service_request_quote_calculated_at] DEFAULT GETDATE(),
    CONSTRAINT [PK_service_request_quote] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_service_request_quote_service_request] FOREIGN KEY ([service_request_id]) REFERENCES [dbo].[service_request] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_service_request_quote_tariff_config] FOREIGN KEY ([tariff_config_id]) REFERENCES [dbo].[tariff_config] ([id]) ON DELETE NO ACTION
);
GO

-- ============================================================
-- DOMAIN MODEL — SHIPMENTS AND OPERATIONS
-- ============================================================

CREATE TABLE [dbo].[shipment] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [service_request_id] BIGINT NOT NULL,
    [conductor_id] BIGINT NOT NULL,
    [vehicle_id] BIGINT NOT NULL,
    [quote_id] BIGINT NOT NULL,
    [started_at] DATETIME NULL,
    [completed_at] DATETIME NULL,
    CONSTRAINT [PK_shipment] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_shipment_service_request] UNIQUE ([service_request_id]),
    CONSTRAINT [FK_shipment_service_request] FOREIGN KEY ([service_request_id]) REFERENCES [dbo].[service_request] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_shipment_conductor] FOREIGN KEY ([conductor_id]) REFERENCES [dbo].[conductor] ([id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_shipment_vehicle] FOREIGN KEY ([vehicle_id]) REFERENCES [dbo].[vehicle] ([id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_shipment_quote] FOREIGN KEY ([quote_id]) REFERENCES [dbo].[service_request_quote] ([id]) ON DELETE NO ACTION
);
GO

-- shipment_status_log.status enum (TINYINT):
--   0 = Accepted | 1 = EnRouteToOrigin | 2 = CargoPickedUp
--   3 = EnRouteToDestination | 4 = Delivered

CREATE TABLE [dbo].[shipment_status_log] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [shipment_id] BIGINT NOT NULL,
    [status] TINYINT NOT NULL,
    [recorded_at] DATETIME NOT NULL CONSTRAINT [DF_shipment_status_log_recorded_at] DEFAULT GETDATE(),
    CONSTRAINT [PK_shipment_status_log] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_shipment_status_log_shipment] FOREIGN KEY ([shipment_id]) REFERENCES [dbo].[shipment] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [dbo].[rating] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [shipment_id] BIGINT NOT NULL,
    [client_id] BIGINT NOT NULL,
    [conductor_id] BIGINT NOT NULL,
    [score] TINYINT NOT NULL,
    [comment] NVARCHAR(1000) NULL,
    [rated_at] DATETIME NOT NULL CONSTRAINT [DF_rating_rated_at] DEFAULT GETDATE(),
    CONSTRAINT [PK_rating] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_rating_shipment] UNIQUE ([shipment_id]),
    CONSTRAINT [CK_rating_score] CHECK ([score] BETWEEN 1 AND 5),
    CONSTRAINT [FK_rating_shipment] FOREIGN KEY ([shipment_id]) REFERENCES [dbo].[shipment] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_rating_client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[client] ([id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_rating_conductor] FOREIGN KEY ([conductor_id]) REFERENCES [dbo].[conductor] ([id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [dbo].[notification] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [user_id] BIGINT NOT NULL,
    [message] NVARCHAR(1000) NOT NULL,
    [channel] NVARCHAR(50) NOT NULL,
    [event_type] NVARCHAR(100) NOT NULL,
    [sent_at] DATETIME NOT NULL CONSTRAINT [DF_notification_sent_at] DEFAULT GETDATE(),
    [read_at] DATETIME NULL,
    CONSTRAINT [PK_notification] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_notification_user] FOREIGN KEY ([user_id])
        REFERENCES [dbo].[user] ([id]) ON DELETE NO ACTION
);
GO

-- incident.status enum (TINYINT):
--   0 = Open | 1 = InReview | 2 = Resolved | 3 = Dismissed

CREATE TABLE [dbo].[incident] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [shipment_id] BIGINT NOT NULL,
    [reported_by_user_id] BIGINT NOT NULL,
    [description] NVARCHAR(2000) NOT NULL,
    [status] TINYINT NOT NULL CONSTRAINT [DF_incident_status] DEFAULT 0,
    [created_at] DATETIME NOT NULL CONSTRAINT [DF_incident_created_at] DEFAULT GETDATE(),
    [resolved_at] DATETIME NULL,
    CONSTRAINT [PK_incident] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_incident_shipment] FOREIGN KEY ([shipment_id]) REFERENCES [dbo].[shipment] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_incident_user] FOREIGN KEY ([reported_by_user_id]) REFERENCES [dbo].[user] ([id]) ON DELETE NO ACTION
);
GO

-- ============================================================
-- INDEXES
-- ============================================================

CREATE NONCLUSTERED INDEX [IX_service_request_client_id]
    ON [dbo].[service_request] ([client_id]);
GO

CREATE NONCLUSTERED INDEX [IX_service_request_status]
    ON [dbo].[service_request] ([status]);
GO

CREATE NONCLUSTERED INDEX [IX_shipment_conductor_id]
    ON [dbo].[shipment] ([conductor_id]);
GO

CREATE NONCLUSTERED INDEX [IX_shipment_status_log_shipment_recorded]
    ON [dbo].[shipment_status_log] ([shipment_id], [recorded_at]);
GO

CREATE NONCLUSTERED INDEX [IX_notification_user_read]
    ON [dbo].[notification] ([user_id], [read_at]);
GO

CREATE NONCLUSTERED INDEX [IX_incident_status]
    ON [dbo].[incident] ([status]);
GO

-- ============================================================
-- STORED PROCEDURES
-- ============================================================

CREATE PROCEDURE [dbo].[user_insert]
    @name NVARCHAR(100),
    @password CHAR(64),
    @email NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[user] ([name], [password], [email])
    VALUES (@name, @password, @email);
    SELECT SCOPE_IDENTITY() AS NewUserId;
END
GO

CREATE PROCEDURE [dbo].[user_delete]
    @id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM [dbo].[user] WHERE [id] = @id;
END
GO

CREATE PROCEDURE [dbo].[user_family_insert]
    @user_id BIGINT,
    @family_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[user_family] ([user_id], [family_id])
    VALUES (@user_id, @family_id);
END
GO

CREATE PROCEDURE [dbo].[user_family_delete]
    @user_id BIGINT,
    @family_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM [dbo].[user_family]
    WHERE [user_id] = @user_id AND [family_id] = @family_id;
END
GO

CREATE PROCEDURE [dbo].[vvd_insert]
    @table_name NVARCHAR(50),
    @digit CHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[vvd] ([table_name], [digit])
    VALUES (@table_name, @digit);
END
GO

CREATE PROCEDURE [dbo].[vvd_delete]
    @table_name NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM [dbo].[vvd] WHERE [table_name] = @table_name;
END
GO

CREATE PROCEDURE [dbo].[family_insert]
    @code VARCHAR(100),
    @description NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[family] ([code], [description])
    VALUES (@code, @description);
    SELECT SCOPE_IDENTITY() AS NewFamilyId;
END
GO

CREATE PROCEDURE [dbo].[family_delete]
    @id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM [dbo].[family] WHERE [id] = @id;
END
GO

CREATE PROCEDURE [dbo].[patent_insert]
    @code VARCHAR(100),
    @description NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[patent] ([code], [description])
    VALUES (@code, @description);
    SELECT SCOPE_IDENTITY() AS NewPatentId;
END
GO

CREATE PROCEDURE [dbo].[patent_delete]
    @id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM [dbo].[patent] WHERE [id] = @id;
END
GO

CREATE PROCEDURE [dbo].[translation_string_upsert]
    @language_id BIGINT,
    @translation_code_id BIGINT,
    @value NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM [dbo].[translation_string]
        WHERE [language_id] = @language_id
          AND [translation_code_id] = @translation_code_id
    )
        UPDATE [dbo].[translation_string]
        SET [value] = @value
        WHERE [language_id] = @language_id
          AND [translation_code_id] = @translation_code_id;
    ELSE
        INSERT INTO [dbo].[translation_string] ([language_id], [translation_code_id], [value])
        VALUES (@language_id, @translation_code_id, @value);
END
GO

CREATE PROCEDURE [dbo].[translation_string_get]
    @language_id BIGINT,
    @translation_code_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [value]
    FROM [dbo].[translation_string]
    WHERE [language_id] = @language_id
      AND [translation_code_id] = @translation_code_id;
END
GO

CREATE PROCEDURE [dbo].[client_insert]
    @user_id BIGINT,
    @first_name NVARCHAR(100),
    @last_name NVARCHAR(100),
    @phone NVARCHAR(30) = NULL,
    @address NVARCHAR(300) = NULL,
    @payment_method NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[client] ([user_id], [first_name], [last_name], [phone], [address], [payment_method])
    VALUES (@user_id, @first_name, @last_name, @phone, @address, @payment_method);
    SELECT SCOPE_IDENTITY() AS NewClientId;
END
GO

CREATE PROCEDURE [dbo].[client_update]
    @id BIGINT,
    @first_name NVARCHAR(100),
    @last_name NVARCHAR(100),
    @phone NVARCHAR(30) = NULL,
    @address NVARCHAR(300) = NULL,
    @payment_method NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[client]
    SET [first_name] = @first_name,
        [last_name] = @last_name,
        [phone] = @phone,
        [address] = @address,
        [payment_method] = @payment_method
    WHERE [id] = @id;
END
GO

CREATE PROCEDURE [dbo].[client_get_by_user]
    @user_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[client] WHERE [user_id] = @user_id;
END
GO

-- ============================================================
-- STORED PROCEDURES — CONDUCTOR
-- ============================================================

-- conductor.status: 0=PendingVerification, 1=Active, 2=Suspended, 3=Rejected

CREATE PROCEDURE [dbo].[conductor_insert]
    @user_id BIGINT,
    @first_name NVARCHAR(100),
    @last_name NVARCHAR(100),
    @dni NVARCHAR(20),
    @phone NVARCHAR(30) = NULL,
    @operation_zone NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[conductor] ([user_id], [first_name], [last_name], [dni], [phone], [operation_zone])
    VALUES (@user_id, @first_name, @last_name, @dni, @phone, @operation_zone);
    SELECT SCOPE_IDENTITY() AS NewConductorId;
END
GO

CREATE PROCEDURE [dbo].[conductor_update_status]
    @id BIGINT,
    @status TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[conductor] SET [status] = @status WHERE [id] = @id;
END
GO

CREATE PROCEDURE [dbo].[conductor_get_by_user]
    @user_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[conductor] WHERE [user_id] = @user_id;
END
GO

CREATE PROCEDURE [dbo].[conductor_update_avg_rating]
    @conductor_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[conductor]
    SET [avg_rating] = (
        SELECT AVG(CAST([score] AS DECIMAL(3,2)))
        FROM [dbo].[rating]
        WHERE [conductor_id] = @conductor_id
    )
    WHERE [id] = @conductor_id;
END
GO

-- ============================================================
-- STORED PROCEDURES — VEHICLE
-- ============================================================

CREATE PROCEDURE [dbo].[vehicle_insert]
    @conductor_id BIGINT,
    @brand NVARCHAR(100),
    @model NVARCHAR(100),
    @year INT,
    @license_plate NVARCHAR(20),
    @cargo_capacity DECIMAL(10,2),
    @vehicle_type NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[vehicle] ([conductor_id], [brand], [model], [year], [license_plate], [cargo_capacity], [vehicle_type])
    VALUES (@conductor_id, @brand, @model, @year, @license_plate, @cargo_capacity, @vehicle_type);
    SELECT SCOPE_IDENTITY() AS NewVehicleId;
END
GO

CREATE PROCEDURE [dbo].[vehicle_update]
    @id BIGINT,
    @brand NVARCHAR(100),
    @model NVARCHAR(100),
    @year INT,
    @license_plate NVARCHAR(20),
    @cargo_capacity DECIMAL(10,2),
    @vehicle_type NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[vehicle]
    SET [brand] = @brand,
        [model] = @model,
        [year] = @year,
        [license_plate] = @license_plate,
        [cargo_capacity] = @cargo_capacity,
        [vehicle_type] = @vehicle_type
    WHERE [id] = @id;
END
GO

CREATE PROCEDURE [dbo].[vehicle_get_by_conductor]
    @conductor_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[vehicle] WHERE [conductor_id] = @conductor_id;
END
GO

-- ============================================================
-- STORED PROCEDURES — CONDUCTOR DOCUMENT
-- ============================================================

CREATE PROCEDURE [dbo].[conductor_document_insert]
    @conductor_id BIGINT,
    @document_type NVARCHAR(100),
    @file_path NVARCHAR(500),
    @expiry_date DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[conductor_document] ([conductor_id], [document_type], [file_path], [expiry_date])
    VALUES (@conductor_id, @document_type, @file_path, @expiry_date);
    SELECT SCOPE_IDENTITY() AS NewDocumentId;
END
GO

CREATE PROCEDURE [dbo].[conductor_document_get_by_conductor]
    @conductor_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[conductor_document]
    WHERE [conductor_id] = @conductor_id
    ORDER BY [uploaded_at] DESC;
END
GO

-- ============================================================
-- STORED PROCEDURES — SERVICE REQUEST
-- ============================================================

-- service_request.status: 0=Pending, 1=Assigned, 2=InProgress, 3=Completed, 4=Cancelled

CREATE PROCEDURE [dbo].[service_request_insert]
    @client_id BIGINT,
    @origin_address NVARCHAR(300),
    @destination_address NVARCHAR(300),
    @cargo_type NVARCHAR(100),
    @required_datetime DATETIME,
    @vehicle_type NVARCHAR(50),
    @tracking_number NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[service_request] (
        [client_id], [origin_address], [destination_address],
        [cargo_type], [required_datetime], [vehicle_type], [tracking_number]
    )
    VALUES (
        @client_id, @origin_address, @destination_address,
        @cargo_type, @required_datetime, @vehicle_type, @tracking_number
    );
    SELECT SCOPE_IDENTITY() AS NewServiceRequestId;
END
GO

CREATE PROCEDURE [dbo].[service_request_update_status]
    @id BIGINT,
    @status TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[service_request] SET [status] = @status WHERE [id] = @id;
END
GO

CREATE PROCEDURE [dbo].[service_request_get_by_tracking]
    @tracking_number NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[service_request] WHERE [tracking_number] = @tracking_number;
END
GO

-- ============================================================
-- STORED PROCEDURES — SHIPMENT
-- ============================================================

CREATE PROCEDURE [dbo].[shipment_insert]
    @service_request_id BIGINT,
    @conductor_id BIGINT,
    @vehicle_id BIGINT,
    @quote_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[shipment] ([service_request_id], [conductor_id], [vehicle_id], [quote_id])
    VALUES (@service_request_id, @conductor_id, @vehicle_id, @quote_id);
    SELECT SCOPE_IDENTITY() AS NewShipmentId;
END
GO

CREATE PROCEDURE [dbo].[shipment_get_by_id]
    @id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        s.*,
        sr.[tracking_number],
        sr.[origin_address],
        sr.[destination_address],
        q.[estimated_amount]
    FROM [dbo].[shipment] s
    INNER JOIN [dbo].[service_request] sr ON sr.[id] = s.[service_request_id]
    INNER JOIN [dbo].[service_request_quote] q ON q.[id] = s.[quote_id]
    WHERE s.[id] = @id;
END
GO

-- ============================================================
-- STORED PROCEDURES — SHIPMENT STATUS LOG
-- ============================================================

-- shipment_status_log.status:
--   0=Accepted, 1=EnRouteToOrigin, 2=CargoPickedUp,
--   3=EnRouteToDestination, 4=Delivered

CREATE PROCEDURE [dbo].[shipment_status_log_insert]
    @shipment_id BIGINT,
    @status TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[shipment_status_log] ([shipment_id], [status])
    VALUES (@shipment_id, @status);
    SELECT SCOPE_IDENTITY() AS NewLogId;
END
GO

-- ============================================================
-- STORED PROCEDURES — RATING
-- ============================================================

CREATE PROCEDURE [dbo].[rating_insert]
    @shipment_id BIGINT,
    @client_id BIGINT,
    @conductor_id BIGINT,
    @score TINYINT,
    @comment NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[rating] ([shipment_id], [client_id], [conductor_id], [score], [comment])
    VALUES (@shipment_id, @client_id, @conductor_id, @score, @comment);

    EXEC [dbo].[conductor_update_avg_rating] @conductor_id;

    SELECT SCOPE_IDENTITY() AS NewRatingId;
END
GO

CREATE PROCEDURE [dbo].[rating_get_by_shipment]
    @shipment_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[rating] WHERE [shipment_id] = @shipment_id;
END
GO

-- ============================================================
-- STORED PROCEDURES — NOTIFICATION
-- ============================================================

CREATE PROCEDURE [dbo].[notification_insert]
    @user_id BIGINT,
    @message NVARCHAR(1000),
    @channel NVARCHAR(50),
    @event_type NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[notification] ([user_id], [message], [channel], [event_type])
    VALUES (@user_id, @message, @channel, @event_type);
    SELECT SCOPE_IDENTITY() AS NewNotificationId;
END
GO

CREATE PROCEDURE [dbo].[notification_mark_read]
    @id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[notification]
    SET [read_at] = GETDATE()
    WHERE [id] = @id AND [read_at] IS NULL;
END
GO

-- ============================================================
-- STORED PROCEDURES — INCIDENT
-- ============================================================

-- incident.status: 0=Open, 1=InReview, 2=Resolved, 3=Dismissed

CREATE PROCEDURE [dbo].[incident_insert]
    @shipment_id BIGINT,
    @reported_by_user_id BIGINT,
    @description NVARCHAR(2000)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[incident] ([shipment_id], [reported_by_user_id], [description])
    VALUES (@shipment_id, @reported_by_user_id, @description);
    SELECT SCOPE_IDENTITY() AS NewIncidentId;
END
GO

CREATE PROCEDURE [dbo].[incident_resolve]
    @id BIGINT,
    @status TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[incident]
    SET [status] = @status,
        [resolved_at] = GETDATE()
    WHERE [id] = @id;
END
GO
