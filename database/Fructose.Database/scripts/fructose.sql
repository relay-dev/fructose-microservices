﻿PRINT 'Running DDL Pre-Process...'
GO

/*
 *  ###########################################################
 *    Create the database
 *  ###########################################################
 */

IF EXISTS (SELECT * FROM sys.databases WHERE name = N'Fructose')
BEGIN
    DROP DATABASE [Fructose]
END
GO

CREATE DATABASE [Fructose]
GO

ALTER DATABASE [Fructose] SET READ_COMMITTED_SNAPSHOT ON;
GO

USE [Fructose]
GO


/*
 *  ###########################################################
 *    Create a procedure to assist with the build script
 *  ###########################################################
 */

CREATE PROCEDURE [dbo].[spDropTable] (@schemaName VARCHAR(255), @tableName VARCHAR(255))
AS
BEGIN

    DECLARE @SQL VARCHAR(MAX);

    IF OBJECT_ID(@schemaName + '.' + @tableName, 'U') IS NOT NULL
    BEGIN
        SET @SQL = 'DROP TABLE [' + @schemaName + '].[' + @tableName + ']'

        EXEC (@SQL);

        PRINT 'SUCCESS: Dropped Table [' + @schemaName + '].[' + @tableName + ']'
    END
    ELSE
    BEGIN
        PRINT 'INFO: Table [' + @schemaName + '].[' + @tableName + '] not found. Skipping Drop statement'
    END

END
GO

PRINT 'Complete'
GO



USE [Fructose]
GO

PRINT 'Running DDL Process...'
GO

/*
 *  ###########################################################
 *    Drop tables if they exist
 *  ###########################################################
 */

EXEC [dbo].[spDropTable] 'dbo', 'PersonPhone'

EXEC [dbo].[spDropTable] 'dbo', 'PhoneHistory'

EXEC [dbo].[spDropTable] 'dbo', 'Phone'

EXEC [dbo].[spDropTable] 'dbo', 'PhoneType'

EXEC [dbo].[spDropTable] 'dbo', 'PersonEmail'

EXEC [dbo].[spDropTable] 'dbo', 'EmailHistory'

EXEC [dbo].[spDropTable] 'dbo', 'Email'

EXEC [dbo].[spDropTable] 'dbo', 'EmailType'

EXEC [dbo].[spDropTable] 'dbo', 'PersonAddress'

EXEC [dbo].[spDropTable] 'dbo', 'AddressHistory'

EXEC [dbo].[spDropTable] 'dbo', 'Address'

EXEC [dbo].[spDropTable] 'dbo', 'AddressType'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerAttribute'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerAttributeType'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerEvent'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerEventType'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerSearch'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerSearchTermType'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerNote'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerNoteType'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerHistory'

EXEC [dbo].[spDropTable] 'dbo', 'Customer'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerType'

EXEC [dbo].[spDropTable] 'dbo', 'CustomerStatus'

EXEC [dbo].[spDropTable] 'dbo', 'PersonHistory'

EXEC [dbo].[spDropTable] 'dbo', 'Person'

GO


/*
 *  ###########################################################
 *    Settings
 *  ###########################################################
 */

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

GO


/*
 *  ###########################################################
 *    CREATE - Person
 *  ###########################################################
 */

CREATE TABLE [dbo].[Person](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [FirstName] [varchar](100) NOT NULL,
    [LastName] [varchar](100) NOT NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__Person__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Person] ADD CONSTRAINT [DF__Person__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[Person] ADD CONSTRAINT [DF__Person__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[Person] ADD CONSTRAINT [DF__Person__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__Person__FirstName
ON [dbo].[Person] (FirstName)
GO

CREATE NONCLUSTERED INDEX IX__Person__LastName
ON [dbo].[Person] (LastName)
GO


/*
 *  ###########################################################
 *    CREATE - PersonHistory
 *  ###########################################################
 */

CREATE TABLE [dbo].[PersonHistory](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [PersonID] [bigint] NOT NULL,
    [FirstName] [varchar](100) NOT NULL,
    [LastName] [varchar](100) NOT NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    CONSTRAINT [PKC__PersonHistory__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PersonHistory] ADD CONSTRAINT [DF__PersonHistory__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[PersonHistory] ADD CONSTRAINT [DF__PersonHistory__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[PersonHistory]  WITH CHECK ADD CONSTRAINT [FKN__PersonHistory__PersonID] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO

ALTER TABLE [dbo].[PersonHistory] CHECK CONSTRAINT [FKN__PersonHistory__PersonID]
GO


/*
 *  ###########################################################
 *    CREATE - CustomerStatus
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerStatus](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NOT NULL,
    [SubStatusName] [varchar](100) NULL,
    [Description] [varchar](4000) NOT NULL,
    [Code] [varchar](50) NOT NULL,
    [DisplayName] [varchar](100) NOT NULL,
    [DisplayOrder] [int] NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__CustomerStatus__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__CustomerStatus__Code] UNIQUE NONCLUSTERED 
    (
        [Code]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__CustomerStatus__Name__SubStatusName] UNIQUE NONCLUSTERED 
    (
        [Name],
        [SubStatusName]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerStatus] ADD CONSTRAINT [DF__CustomerStatus__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerStatus] ADD CONSTRAINT [DF__CustomerStatus__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerStatus] ADD CONSTRAINT [DF__CustomerStatus__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__CustomerStatus__Name
ON [dbo].[CustomerStatus] (Name)
GO

CREATE NONCLUSTERED INDEX IX__CustomerStatus__SubStatusName
ON [dbo].[CustomerStatus] (SubStatusName)
GO

CREATE NONCLUSTERED INDEX IX__CustomerStatus__Code
ON [dbo].[CustomerStatus] (Code)
GO


/*
 *  ###########################################################
 *    CREATE - CustomerType
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NOT NULL,
    [Description] [varchar](4000) NOT NULL,
    [Code] [varchar](50) NOT NULL,
    [DisplayName] [varchar](100) NOT NULL,
    [DisplayOrder] [int] NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__CustomerType__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__CustomerType__Name] UNIQUE NONCLUSTERED 
    (
        [Name]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__CustomerType__Code] UNIQUE NONCLUSTERED 
    (
        [Code]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerType] ADD CONSTRAINT [DF__CustomerType__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerType] ADD CONSTRAINT [DF__CustomerType__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerType] ADD CONSTRAINT [DF__CustomerType__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__CustomerType__Name
ON [dbo].[CustomerType] (Name)
GO

CREATE NONCLUSTERED INDEX IX__CustomerType__Code
ON [dbo].[CustomerType] (Code)
GO


/*
 *  ###########################################################
 *    CREATE - Customer
 *  ###########################################################
 */

CREATE TABLE [dbo].[Customer](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [OrganizationID] [bigint] NOT NULL,
    [PersonID] [bigint] NOT NULL,
    [CustomerStatusID] [int] NOT NULL,
    [CustomerTypeID] [int] NOT NULL,
    [CustomerNumber] [varchar] (50) NOT NULL,
    [JoinDate] [datetime] NOT NULL,
    [IsActive] [bit] NOT NULL,
    [ReferenceIdentifier] [varchar](100) NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__Customer__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__Customer__PersonID] UNIQUE NONCLUSTERED 
    (
        [PersonID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__Customer__ReferenceIdentifier] UNIQUE NONCLUSTERED 
    (
        [ReferenceIdentifier]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF__Customer__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF__Customer__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF__Customer__JoinDate]
DEFAULT (getutcdate()) FOR [JoinDate]
GO

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF__Customer__IsActive]
DEFAULT 1 FOR [IsActive]
GO

ALTER TABLE [dbo].[Customer]  WITH CHECK ADD CONSTRAINT [FKN__Customer__PersonID] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO

ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FKN__Customer__PersonID]
GO

ALTER TABLE [dbo].[Customer]  WITH CHECK ADD CONSTRAINT [FKN__Customer__CustomerStatusID] FOREIGN KEY([CustomerStatusID])
REFERENCES [dbo].[CustomerStatus] ([ID])
GO

ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FKN__Customer__CustomerStatusID]
GO

ALTER TABLE [dbo].[Customer]  WITH CHECK ADD CONSTRAINT [FKN__Customer__CustomerTypeID] FOREIGN KEY([CustomerTypeID])
REFERENCES [dbo].[CustomerType] ([ID])
GO

ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FKN__Customer__CustomerTypeID]
GO

CREATE NONCLUSTERED INDEX IX__Customer__ReferenceIdentifier
ON [dbo].[Customer] (ReferenceIdentifier)
GO


/*
 *  ###########################################################
 *    CREATE - CustomerHistory
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerHistory](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [CustomerID] [bigint] NOT NULL,
    [OrganizationID] [bigint] NOT NULL,
    [PersonID] [bigint] NOT NULL,
    [CustomerStatusID] [int] NOT NULL,
    [CustomerTypeID] [int] NOT NULL,
    [CustomerNumber] [varchar] (100) NOT NULL,
    [JoinDate] [datetime] NOT NULL,
    [IsActive] [bit] NOT NULL,
    [ReferenceIdentifier] [varchar](100) NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    CONSTRAINT [PKC__CustomerHistory__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerHistory] ADD CONSTRAINT [DF__CustomerHistory__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerHistory] ADD CONSTRAINT [DF__CustomerHistory__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerHistory]  WITH CHECK ADD CONSTRAINT [FKN__CustomerHistory__CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([ID])
GO

ALTER TABLE [dbo].[CustomerHistory] CHECK CONSTRAINT [FKN__CustomerHistory__CustomerID]
GO


/*
 *  ###########################################################
 *    CREATE - CustomerNoteType
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerNoteType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NOT NULL,
    [Description] [varchar](4000) NOT NULL,
    [DisplayName] [varchar](100) NOT NULL,
    [DisplayOrder] [int] NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__CustomerNoteType__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__CustomerNoteType__Name] UNIQUE NONCLUSTERED 
    (
        [Name]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerNoteType] ADD CONSTRAINT [DF__CustomerNoteType__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerNoteType] ADD CONSTRAINT [DF__CustomerNoteType__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerNoteType] ADD CONSTRAINT [DF__CustomerNoteType__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__CustomerNote__Name
ON [dbo].[CustomerNoteType] (Name)
GO


/*
 *  ###########################################################
 *    CREATE - CustomerNote
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerNote](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [CustomerID] [bigint] NOT NULL,
    [CustomerNoteTypeID] [int] NOT NULL,
    [Note] [varchar] (max) NOT NULL,
    [IsSuppressed] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__CustomerNote__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerNote] ADD CONSTRAINT [DF__CustomerNote__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerNote] ADD CONSTRAINT [DF__CustomerNotel__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerNote] ADD CONSTRAINT [DF__CustomerNote__IsSuppressed]
DEFAULT 0 FOR [IsSuppressed]
GO

ALTER TABLE [dbo].[CustomerNote]  WITH CHECK ADD CONSTRAINT [FKN__CustomerNote__CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([ID])
GO

ALTER TABLE [dbo].[CustomerNote] CHECK CONSTRAINT [FKN__CustomerNote__CustomerID]
GO

ALTER TABLE [dbo].[CustomerNote]  WITH CHECK ADD CONSTRAINT [FKN__CustomerNote__CustomerNoteTypeID] FOREIGN KEY([CustomerNoteTypeID])
REFERENCES [dbo].[CustomerNoteType] ([ID])
GO

ALTER TABLE [dbo].[CustomerNote] CHECK CONSTRAINT [FKN__CustomerNote__CustomerNoteTypeID]
GO


/*
 *  ###########################################################
 *    CREATE - CustomerSearchTermType
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerSearchTermType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NOT NULL,
    [Description] [varchar](4000) NOT NULL,
    [DisplayName] [varchar](100) NOT NULL,
    [DisplayOrder] [int] NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__CustomerSearchTermType__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__CustomerSearchTermType__Name] UNIQUE NONCLUSTERED 
    (
        [Name]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerSearchTermType] ADD CONSTRAINT [DF__CustomerSearchTermType__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerSearchTermType] ADD CONSTRAINT [DF__CustomerSearchTermType__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerSearchTermType] ADD CONSTRAINT [DF__CustomerSearchTermType__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__CustomerSearchTermType__Name
ON [dbo].[CustomerSearchTermType] (Name)
GO


/*
 *  ###########################################################
 *    CREATE - CustomerSearch
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerSearch](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [CustomerID] [bigint] NOT NULL,
    [SearchTermTypeID] [int] NOT NULL,
    [SearchTerm] [varchar](900) NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    CONSTRAINT [PKC__CustomerSearch__ID] PRIMARY KEY NONCLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerSearch] ADD CONSTRAINT [DF__CustomerSearch__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerSearch] ADD CONSTRAINT [DF__CustomerSearch__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerSearch]  WITH CHECK ADD CONSTRAINT [FKN__CustomerSearch__CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([ID])
GO

ALTER TABLE [dbo].[CustomerSearch] CHECK CONSTRAINT [FKN__CustomerSearch__CustomerID]
GO

ALTER TABLE [dbo].[CustomerSearch]  WITH CHECK ADD CONSTRAINT [FKN__CustomerSearch__SearchTermTypeID] FOREIGN KEY([SearchTermTypeID])
REFERENCES [dbo].[CustomerSearchTermType] ([ID])
GO

ALTER TABLE [dbo].[CustomerSearch] CHECK CONSTRAINT [FKN__CustomerSearch__SearchTermTypeID]
GO

CREATE CLUSTERED INDEX IX__CustomerSearch__SearchTerm
ON [dbo].[CustomerSearch] (SearchTerm)
GO


/*
 *  ###########################################################
 *    CREATE - CustomerEventType
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerEventType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NOT NULL,
    [Description] [varchar](4000) NOT NULL,
    [DisplayName] [varchar](100) NOT NULL,
    [DisplayOrder] [int] NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__CustomerEventType__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__CustomerEventType__Name] UNIQUE NONCLUSTERED 
    (
        [Name]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerEventType] ADD CONSTRAINT [DF__CustomerEventType__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerEventType] ADD CONSTRAINT [DF__CustomerEventType__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerEventType] ADD CONSTRAINT [DF__CustomerEventType__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__CustomerEventType__Name
ON [dbo].[CustomerEventType] (Name)
GO


/*
 *  ###########################################################
 *    CREATE - CustomerEvent
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerEvent](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [CustomerID] [bigint] NOT NULL,
    [CustomerEventTypeID] [int] NOT NULL,
    [EventDate] [datetime] NOT NULL,
    [Notes] [varchar](max) NULL,
    [IsSuppressed] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__CustomerEvent__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerEvent] ADD CONSTRAINT [DF__CustomerEvent__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerEvent] ADD CONSTRAINT [DF__CustomerEvent__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerEvent] ADD CONSTRAINT [DF__CustomerEvent__EventDate]
DEFAULT (getutcdate()) FOR [EventDate]
GO

ALTER TABLE [dbo].[CustomerEvent] ADD CONSTRAINT [DF__CustomerEvent__IsSuppressed]
DEFAULT 0 FOR [IsSuppressed]
GO

ALTER TABLE [dbo].[CustomerEvent]  WITH CHECK ADD CONSTRAINT [FKN__CustomerEvent__CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[CustomerEvent] ([ID])
GO

ALTER TABLE [dbo].[CustomerEvent] CHECK CONSTRAINT [FKN__CustomerEvent__CustomerID]
GO

ALTER TABLE [dbo].[CustomerEvent]  WITH CHECK ADD CONSTRAINT [FKN__CustomerEvent__CustomerEventTypeID] FOREIGN KEY([CustomerEventTypeID])
REFERENCES [dbo].[CustomerEventType] ([ID])
GO

ALTER TABLE [dbo].[CustomerEvent] CHECK CONSTRAINT [FKN__CustomerEvent__CustomerEventTypeID]
GO


/*
 *  ###########################################################
 *    CREATE - CustomerAttributeType
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerAttributeType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NOT NULL,
    [Description] [varchar](4000) NOT NULL,
    [DisplayName] [varchar](100) NOT NULL,
    [DisplayOrder] [int] NULL,
    [IsValueEncrypted] [bit] NOT NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__CustomerAttributeType__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__CustomerAttributeType__Name] UNIQUE NONCLUSTERED 
    (
        [Name]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerAttributeType] ADD CONSTRAINT [DF__CustomerAttributeType__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerAttributeType] ADD CONSTRAINT [DF__CustomerAttributeType__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerAttributeType] ADD CONSTRAINT [DF__CustomerAttributeType__IsValueEncrypted]
DEFAULT 0 FOR [IsValueEncrypted]
GO

ALTER TABLE [dbo].[CustomerAttributeType] ADD CONSTRAINT [DF__CustomerAttributeType__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__CustomerEventType__Name
ON [dbo].[CustomerAttributeType] (Name)
GO

/*
 *  ###########################################################
 *    CREATE - CustomerAttribute
 *  ###########################################################
 */

CREATE TABLE [dbo].[CustomerAttribute](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [CustomerID] [bigint] NOT NULL,
    [CustomerAttributeTypeID] [int] NOT NULL,
    [AttributeValue] [varchar](4000) NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__CustomerAttribute__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerAttribute] ADD CONSTRAINT [DF__CustomerAttribute__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[CustomerAttribute] ADD CONSTRAINT [DF__CustomerAttribute__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CustomerAttribute]  WITH CHECK ADD CONSTRAINT [FKN__CustomerAttribute__CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([ID])
GO

ALTER TABLE [dbo].[CustomerAttribute] CHECK CONSTRAINT [FKN__CustomerAttribute__CustomerID]
GO

ALTER TABLE [dbo].[CustomerAttribute]  WITH CHECK ADD CONSTRAINT [FKN__CustomerAttributet__CustomerAttributeTypeID] FOREIGN KEY([CustomerAttributeTypeID])
REFERENCES [dbo].[CustomerAttributeType] ([ID])
GO

ALTER TABLE [dbo].[CustomerAttribute] CHECK CONSTRAINT [FKN__CustomerAttributet__CustomerAttributeTypeID]
GO


/*
 *  ###########################################################
 *    CREATE - AddressType
 *  ###########################################################
 */

CREATE TABLE [dbo].[AddressType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NOT NULL,
    [Description] [varchar](4000) NOT NULL,
    [DisplayName] [varchar](100) NOT NULL,
    [DisplayOrder] [int] NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__AddressType__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__AddressType__Name] UNIQUE NONCLUSTERED 
    (
        [Name]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AddressType] ADD CONSTRAINT [DF__AddressType__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[AddressType] ADD CONSTRAINT [DF__AddressType__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[AddressType] ADD CONSTRAINT [DF__AddressType__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__AddressType__Name
ON [dbo].[AddressType] (Name)
GO


/*
 *  ###########################################################
 *    CREATE - Address
 *  ###########################################################
 */

CREATE TABLE [dbo].[Address](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [AddressTypeID] [int] NOT NULL,
    [GeographyID] [bigint] NULL,
    [Line1] [varchar] (500) NOT NULL,
    [Line2] [varchar] (500) NULL,
    [Line3] [varchar] (500) NULL,
    [City] [varchar] (200) NOT NULL,
    [StateProv] [varchar] (2) NOT NULL,
    [PostalCode] [varchar] (20) NOT NULL,
    [CountryCode] [varchar] (2) NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__Address__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Address] ADD CONSTRAINT [DF__Address__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[Address] ADD CONSTRAINT [DF__Address__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[Address]  WITH CHECK ADD CONSTRAINT [FKN__Address__AddressTypeID] FOREIGN KEY([AddressTypeID])
REFERENCES [dbo].[AddressType] ([ID])
GO

ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FKN__Address__AddressTypeID]
GO

CREATE NONCLUSTERED INDEX IX__Address__Line1
ON [dbo].[Address] (Line1)
GO

CREATE NONCLUSTERED INDEX IX__Address__City
ON [dbo].[Address] (City)
GO

CREATE NONCLUSTERED INDEX IX__Address__StateProv
ON [dbo].[Address] (StateProv)
GO

CREATE NONCLUSTERED INDEX IX__Address__PostalCode
ON [dbo].[Address] (PostalCode)
GO

CREATE NONCLUSTERED INDEX IX__Address__CountryCode
ON [dbo].[Address] (CountryCode)
GO


/*
 *  ###########################################################
 *    CREATE - AddressHistory
 *  ###########################################################
 */

CREATE TABLE [dbo].[AddressHistory](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [AddressID] [bigint] NOT NULL,
    [AddressTypeID] [int] NOT NULL,
    [GeographyID] [bigint] NULL,
    [Line1] [varchar] (500) NOT NULL,
    [Line2] [varchar] (500) NULL,
    [Line3] [varchar] (500) NULL,
    [City] [varchar] (200) NOT NULL,
    [StateProv] [varchar] (2) NOT NULL,
    [PostalCode] [varchar] (20) NOT NULL,
    [CountryCode] [varchar] (2) NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    CONSTRAINT [PKC__AddressHistory__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AddressHistory] ADD CONSTRAINT [DF__AddressHistory__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[AddressHistory] ADD CONSTRAINT [DF__AddressHistory__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[AddressHistory]  WITH CHECK ADD CONSTRAINT [FKN__AddressHistory__AddressID] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([ID])
GO

ALTER TABLE [dbo].[AddressHistory] CHECK CONSTRAINT [FKN__AddressHistory__AddressID]
GO


/*
 *  ###########################################################
 *    CREATE - PersonAddress
 *  ###########################################################
 */

CREATE TABLE [dbo].[PersonAddress](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [PersonID] [bigint] NOT NULL,
    [AddressID] [bigint] NOT NULL,
    [IsPhysical] [bit] NOT NULL,
    [IsShipping] [bit] NOT NULL,
    [IsBilling] [bit] NOT NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__PersonAddress__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PersonAddress] ADD CONSTRAINT [DF__PersonAddress__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[PersonAddress] ADD CONSTRAINT [DF__PersonAddress__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[PersonAddress] ADD CONSTRAINT [DF__PersonAddress__IsPhysical]
DEFAULT 1 FOR [IsPhysical]
GO

ALTER TABLE [dbo].[PersonAddress] ADD CONSTRAINT [DF__PersonAddress__IsShipping]
DEFAULT 1 FOR [IsShipping]
GO

ALTER TABLE [dbo].[PersonAddress] ADD CONSTRAINT [DF__PersonAddress__IsBilling]
DEFAULT 1 FOR [IsBilling]
GO

ALTER TABLE [dbo].[PersonAddress] ADD CONSTRAINT [DF__PersonAddress__IsActive]
DEFAULT 1 FOR [IsActive]
GO

ALTER TABLE [dbo].[PersonAddress]  WITH CHECK ADD CONSTRAINT [FKN__PersonAddress__PersonID] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO

ALTER TABLE [dbo].[PersonAddress] CHECK CONSTRAINT [FKN__PersonAddress__PersonID]
GO

ALTER TABLE [dbo].[PersonAddress]  WITH CHECK ADD CONSTRAINT [FKN__PersonAddress__AddressID] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([ID])
GO

ALTER TABLE [dbo].[PersonAddress] CHECK CONSTRAINT [FKN__PersonAddress__AddressID]
GO


/*
 *  ###########################################################
 *    CREATE - EmailType
 *  ###########################################################
 */

CREATE TABLE [dbo].[EmailType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NOT NULL,
    [Description] [varchar](4000) NOT NULL,
    [DisplayName] [varchar](100) NOT NULL,
    [DisplayOrder] [int] NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__EmailType__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__EmailType__Name] UNIQUE NONCLUSTERED 
    (
        [Name]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[EmailType] ADD CONSTRAINT [DF__EmailType__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[EmailType] ADD CONSTRAINT [DF__EmailType__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[EmailType] ADD CONSTRAINT [DF__EmailType__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__EmailType__Name
ON [dbo].[EmailType] (Name)
GO


/*
 *  ###########################################################
 *    CREATE - Email
 *  ###########################################################
 */

CREATE TABLE [dbo].[Email](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [EmailTypeID] [int] NOT NULL,
    [EmailAddress] [varchar] (500) NOT NULL,
    [IsValidated] [bit] NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__Email__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Email] ADD CONSTRAINT [DF__Email__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[Email] ADD CONSTRAINT [DF__Email__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]

ALTER TABLE [dbo].[Email]  WITH CHECK ADD CONSTRAINT [FKN__Email__EmailTypeID] FOREIGN KEY([EmailTypeID])
REFERENCES [dbo].[EmailType] ([ID])
GO

ALTER TABLE [dbo].[Email] CHECK CONSTRAINT [FKN__Email__EmailTypeID]
GO

CREATE NONCLUSTERED INDEX IX__Email__EmailAddress
ON [dbo].[Email] (EmailAddress)
GO


/*
 *  ###########################################################
 *    CREATE - EmailHistory
 *  ###########################################################
 */

CREATE TABLE [dbo].[EmailHistory](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [EmailID] [bigint] NOT NULL,
    [EmailTypeID] [int] NOT NULL,
    [EmailAddress] [varchar] (500) NOT NULL,
    [IsValidated] [bit] NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    CONSTRAINT [PKC__EmailHistory__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[EmailHistory] ADD CONSTRAINT [DF__EmailHistory__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[EmailHistory] ADD CONSTRAINT [DF__EmailHistory__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[EmailHistory]  WITH CHECK ADD CONSTRAINT [FKN__EmailHistory__EmailID] FOREIGN KEY([EmailID])
REFERENCES [dbo].[Email] ([ID])
GO

ALTER TABLE [dbo].[EmailHistory] CHECK CONSTRAINT [FKN__EmailHistory__EmailID]
GO


/*
 *  ###########################################################
 *    CREATE - PersonEmail
 *  ###########################################################
 */

CREATE TABLE [dbo].[PersonEmail](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [PersonID] [bigint] NOT NULL,
    [EmailID] [bigint] NOT NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__PersonEmail__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PersonEmail] ADD CONSTRAINT [DF__PersonEmail__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[PersonEmail] ADD CONSTRAINT [DF__PersonEmail__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[PersonEmail] ADD CONSTRAINT [DF__PersonEmail__IsActive]
DEFAULT 1 FOR [IsActive]
GO

ALTER TABLE [dbo].[PersonEmail]  WITH CHECK ADD CONSTRAINT [FKN__PersonEmail__PersonID] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO

ALTER TABLE [dbo].[PersonEmail] CHECK CONSTRAINT [FKN__PersonEmail__PersonID]
GO

ALTER TABLE [dbo].[PersonEmail]  WITH CHECK ADD CONSTRAINT [FKN__PersonEmail__EmailID] FOREIGN KEY([EmailID])
REFERENCES [dbo].[Email] ([ID])
GO

ALTER TABLE [dbo].[PersonEmail] CHECK CONSTRAINT [FKN__PersonEmail__EmailID]
GO


/*
 *  ###########################################################
 *    CREATE - PhoneType
 *  ###########################################################
 */

CREATE TABLE [dbo].[PhoneType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NOT NULL,
    [Description] [varchar](4000) NOT NULL,
    [DisplayName] [varchar](100) NOT NULL,
    [DisplayOrder] [int] NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__PhoneType__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [UKC__PhoneType__Name] UNIQUE NONCLUSTERED 
    (
        [Name]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PhoneType] ADD CONSTRAINT [DF__PhoneType__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[PhoneType] ADD CONSTRAINT [DF__PhoneType__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[PhoneType] ADD CONSTRAINT [DF__PhoneType__IsActive]
DEFAULT 1 FOR [IsActive]
GO

CREATE NONCLUSTERED INDEX IX__PhoneType__Name
ON [dbo].[PhoneType] (Name)
GO


/*
 *  ###########################################################
 *    CREATE - Phone
 *  ###########################################################
 */

CREATE TABLE [dbo].[Phone](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [PhoneTypeID] [int] NOT NULL,
    [PhoneNumber] [varchar] (50) NOT NULL,
    [PhoneNumberNumeric] [varchar] (50) NOT NULL,
    [IsValidated] [bit] NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__Phone__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Phone] ADD CONSTRAINT [DF__Phone__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[Phone] ADD CONSTRAINT [DF__Phone__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]

ALTER TABLE [dbo].[Phone]  WITH CHECK ADD CONSTRAINT [FKN__Phone__PhoneTypeID] FOREIGN KEY([PhoneTypeID])
REFERENCES [dbo].[PhoneType] ([ID])
GO

ALTER TABLE [dbo].[Phone] CHECK CONSTRAINT [FKN__Phone__PhoneTypeID]
GO

CREATE NONCLUSTERED INDEX IX__Phone__PhoneNumber
ON [dbo].[Phone] (PhoneNumber)
GO


/*
 *  ###########################################################
 *    CREATE - PhoneHistory
 *  ###########################################################
 */

CREATE TABLE [dbo].[PhoneHistory](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [PhoneID] [bigint] NOT NULL,
    [PhoneTypeID] [int] NOT NULL,
    [PhoneNumber] [varchar] (50) NOT NULL,
    [IsValidated] [bit] NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    CONSTRAINT [PKC__PhoneHistory__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PhoneHistory] ADD CONSTRAINT [DF__PhoneHistory__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[PhoneHistory] ADD CONSTRAINT [DF__PhoneHistory__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[PhoneHistory]  WITH CHECK ADD CONSTRAINT [FKN__PhoneHistory__PhoneID] FOREIGN KEY([PhoneID])
REFERENCES [dbo].[Phone] ([ID])
GO

ALTER TABLE [dbo].[PhoneHistory] CHECK CONSTRAINT [FKN__PhoneHistory__PhoneID]
GO


/*
 *  ###########################################################
 *    CREATE - PersonPhone
 *  ###########################################################
 */

CREATE TABLE [dbo].[PersonPhone](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [PersonID] [bigint] NOT NULL,
    [PhoneID] [bigint] NOT NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedBy] [varchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](100) NULL,
    [ModifiedDate] [datetime] NULL,
    [RowVersion] [rowversion] NOT NULL,
    CONSTRAINT [PKC__PersonPhone__ID] PRIMARY KEY CLUSTERED 
    (
        [ID]
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PersonPhone] ADD CONSTRAINT [DF__PersonPhone__CreatedBy]
DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[PersonPhone] ADD CONSTRAINT [DF__PersonPhone__CreatedDate]
DEFAULT (getutcdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[PersonPhone] ADD CONSTRAINT [DF__PersonPhone__IsActive]
DEFAULT 1 FOR [IsActive]
GO

ALTER TABLE [dbo].[PersonPhone]  WITH CHECK ADD CONSTRAINT [FKN__PersonPhone__PersonID] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO

ALTER TABLE [dbo].[PersonPhone] CHECK CONSTRAINT [FKN__PersonPhone__PersonID]
GO

ALTER TABLE [dbo].[PersonPhone]  WITH CHECK ADD CONSTRAINT [FKN__PersonPhone__PhoneID] FOREIGN KEY([PhoneID])
REFERENCES [dbo].[Phone] ([ID])
GO

ALTER TABLE [dbo].[PersonPhone] CHECK CONSTRAINT [FKN__PersonPhone__PhoneID]
GO

PRINT 'Complete'
GO


USE [Fructose]
GO

PRINT 'Running DDL Post-Process...'
GO

CREATE VIEW [dbo].[vwPerson]
AS
    SELECT
          p.[ID]
        , p.[FirstName]
        , p.[LastName]
        , p.[IsActive]
        , p.[CreatedBy]
        , p.[CreatedDate]
        , p.[ModifiedBy]
        , p.[ModifiedDate]
    FROM [dbo].[Person] p (NOLOCK)
GO

CREATE VIEW [dbo].[vwCustomer]
AS
    SELECT
          c.[ID]
        , c.[OrganizationID]
        , c.[PersonID]
        , c.[CustomerStatusID]
        , c.[CustomerTypeID]
        , c.[CustomerNumber]
        , p.[FirstName]
        , p.[LastName]
        , c.[JoinDate]
        , cs.[Name]                      AS [CustomerStatusName]
        , ct.[Name]                      AS [CustomerTypeName]
        , c.[ReferenceIdentifier]
        , c.[IsActive]
        , p.[IsActive]                   AS [IsPersonActive]
        , c.[CreatedBy]
        , c.[CreatedDate]
        , c.[ModifiedBy]
        , c.[ModifiedDate]
        , p.[CreatedBy]                  AS [PersonCreatedBy]
        , p.[CreatedDate]                AS [PersonCreatedDate]
        , p.[ModifiedBy]                 AS [PersonModifiedBy]
        , p.[ModifiedDate]               AS [PersonModifiedDate]
    FROM [dbo].[Customer] c (NOLOCK)
        INNER JOIN [dbo].[CustomerStatus] cs (NOLOCK) ON c.CustomerStatusID = cs.ID
        INNER JOIN [dbo].[CustomerType] ct (NOLOCK) ON c.CustomerTypeID = ct.ID
        INNER JOIN [dbo].[Person] p (NOLOCK) ON c.PersonID = p.ID
GO

PRINT 'Complete'
GO



USE [Fructose]
GO

PRINT 'Running DML Pre-Process...'
GO

PRINT 'Complete'
GO


USE [Fructose]
GO

DECLARE
  @createdBy       AS VARCHAR(100)        = 'sferguson'
, @createdDate     AS DATETIME            = CURRENT_TIMESTAMP

BEGIN

/*
 *  ###########################################################
 *    INSERT - CustomerStatus
 *  ###########################################################
 */

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerStatus] WHERE [Name] = 'Pending' AND [SubStatusName] IS NULL)
BEGIN
    INSERT INTO [dbo].[CustomerStatus] ([Name], [SubStatusName], [Description], [Code], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Pending', NULL, 'The Customer data is being held in until a future date/time', 'PEND', 'Pending', 100, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerStatus] WHERE [Name] = 'Pending' AND [SubStatusName] = 'Error')
BEGIN
    INSERT INTO [dbo].[CustomerStatus] ([Name], [SubStatusName], [Description], [Code], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Pending', 'Error', 'The Customer data is being held due to a validation error', 'PNDE', 'Pending - Error', 200, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerStatus] WHERE [Name] = 'Active' AND [SubStatusName] IS NULL)
BEGIN
    INSERT INTO [dbo].[CustomerStatus] ([Name], [SubStatusName], [Description], [Code], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Active', NULL, 'The Customer is considered accepted', 'ACTV', 'Active', 300, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerStatus] WHERE [Name] = 'Active' AND [SubStatusName] = 'Cancel Requested')
BEGIN
    INSERT INTO [dbo].[CustomerStatus] ([Name], [SubStatusName], [Description], [Code], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Active', 'Cancel Requested', 'The Customer is still active but a cancel has been requested and the Customer is in a state where they can be won back', 'ATVC', 'Active - Cancel Requested', 400, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerStatus] WHERE [Name] = 'Cancelled' AND [SubStatusName] IS NULL)
BEGIN
    INSERT INTO [dbo].[CustomerStatus] ([Name], [SubStatusName], [Description], [Code], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Cancelled', NULL, 'The Customer was once active with the platform but the cancel request has been fulfilled', 'CANC', 'Cancelled', 500, 1, @createdBy, @createdDate)
END

/*
 *  ###########################################################
 *    INSERT - CustomerType
 *  ###########################################################
 */

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerType] WHERE [Name] = 'Personal')
BEGIN
    INSERT INTO [dbo].[CustomerType] ([Name], [Description], [Code], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Personal', 'The Customer has a personal account for their use only', 'PERS', 'Personal', 100, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerType] WHERE [Name] = 'Business')
BEGIN
    INSERT INTO [dbo].[CustomerType] ([Name], [Description], [Code], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Business', 'The Customer is considered to be a business organization', 'BUSI', 'Business', 200, 1, @createdBy, @createdDate)
END

/*
 *  ###########################################################
 *    INSERT - CustomerNoteType
 *  ###########################################################
 */

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerNoteType] WHERE [Name] = 'General')
BEGIN
    INSERT INTO [dbo].[CustomerNoteType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('General', 'A general note to be left on the Customer''s account', 'General', 100, 1, @createdBy, @createdDate)
END

/*
 *  ###########################################################
 *    INSERT - CustomerSearchTermType
 *  ###########################################################
 */

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'FirstName')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('FirstName', 'The first name of the Customer', 'First Name', 100, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'LastName')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('LastName', 'The last name of the Customer', 'Last Name', 200, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'CustomerNumber')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('CustomerNumber', 'The Customer''s unique identifier (known by the Customer, not for internal use only)', 'Customer Number', 300, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'AddressLine1')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('AddressLine1', 'Line 1 of the Customer''s address (regardless of AddressTypeID)', 'Address Line 1', 400, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'AddressLine2')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('AddressLine2', 'Line 2 of the Customer''s address (regardless of AddressTypeID)', 'Address Line 2', 500, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'AddressLine3')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('AddressLine3', 'Line 3 of the Customer''s address (regardless of AddressTypeID)', 'Address Line 3', 600, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'City')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('City', 'The City the Customer''s address (regardless of AddressTypeID)', 'City', 700, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'StateProv')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('StateProv', 'The State the Customer''s address (regardless of AddressTypeID)', 'StateProv', 800, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'PostalCode')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('PostalCode', 'The Postal Code the Customer''s address (regardless of AddressTypeID)', 'Postal Code', 900, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'EmailAddress')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('EmailAddress', 'The Email Address the Customer (regardless of EmailTypeID)', 'Email Address', 1000, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'PhoneNumber')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('PhoneNumber', 'The Phone Number the Customer (regardless of PhoneTypeID)', 'Phone Number', 1100, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerSearchTermType] WHERE [Name] = 'CustomerAttribute')
BEGIN
    INSERT INTO [dbo].[CustomerSearchTermType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('CustomerAttribute', 'The Attribute Value of the Customer', 'Customer Attribute', 1200, 1, @createdBy, @createdDate)
END

/*
 *  ###########################################################
 *    INSERT - CustomerEventType
 *  ###########################################################
 */

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerEventType] WHERE [Name] = 'StatusChange')
BEGIN
    INSERT INTO [dbo].[CustomerEventType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('StatusChange', 'Records whenever a Customer''s status changes', 'Status Change', 100, 1, @createdBy, @createdDate)
END

/*
 *  ###########################################################
 *    INSERT - CustomerAttributeType
 *  ###########################################################
 */

IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomerAttributeType] WHERE [Name] = 'NationalIdentifier')
BEGIN
    INSERT INTO [dbo].[CustomerAttributeType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsValueEncrypted], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('NationalIdentifier', 'The national unique identifier of the Customer (i.e. for the US, NationalIdentifier is synonymous with Social Security Number)', 'National Identifier', 100, 1, 1, @createdBy, @createdDate)
END

/*
 *  ###########################################################
 *    INSERT - AddressType
 *  ###########################################################
 */

IF NOT EXISTS (SELECT 1 FROM [dbo].[AddressType] WHERE [Name] = 'Home')
BEGIN
    INSERT INTO [dbo].[AddressType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Home', 'Indicates a Home address', 'Home', 100, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[AddressType] WHERE [Name] = 'Billing')
BEGIN
    INSERT INTO [dbo].[AddressType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Billing', 'Indicates a Billing address', 'Billing', 200, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[AddressType] WHERE [Name] = 'Shipping')
BEGIN
    INSERT INTO [dbo].[AddressType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Shipping', 'Indicates a Shipping address', 'Shipping', 300, 1, @createdBy, @createdDate)
END

/*
 *  ###########################################################
 *    INSERT - EmailType
 *  ###########################################################
 */

IF NOT EXISTS (SELECT 1 FROM [dbo].[EmailType] WHERE [Name] = 'Personal')
BEGIN
    INSERT INTO [dbo].[EmailType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Personal', 'Indicates a Personal email address', 'Personal', 100, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[EmailType] WHERE [Name] = 'Business')
BEGIN
    INSERT INTO [dbo].[EmailType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Business', 'Indicates a Business email address', 'Business', 200, 1, @createdBy, @createdDate)
END

/*
 *  ###########################################################
 *    INSERT - PhoneType
 *  ###########################################################
 */

IF NOT EXISTS (SELECT 1 FROM [dbo].[PhoneType] WHERE [Name] = 'Home')
BEGIN
    INSERT INTO [dbo].[PhoneType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Home', 'Indicates a Home phone number', 'Home', 100, 1, @createdBy, @createdDate)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[PhoneType] WHERE [Name] = 'Work')
BEGIN
    INSERT INTO [dbo].[PhoneType] ([Name], [Description], [DisplayName], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate])
    VALUES ('Work', 'Indicates a Work phone number', 'Work', 200, 1, @createdBy, @createdDate)
END

END

USE [Fructose]
GO

PRINT 'Running DML Post-Process...'
GO

SELECT * 
FROM [dbo].[vwPerson]

SELECT * 
FROM [dbo].[vwCustomer]

SELECT * 
FROM [dbo].[CustomerStatus]

SELECT * 
FROM [dbo].[CustomerType]

SELECT * 
FROM [dbo].[CustomerNoteType]

SELECT * 
FROM [dbo].[CustomerSearchTermType]

SELECT * 
FROM [dbo].[CustomerEventType]

SELECT * 
FROM [dbo].[CustomerAttributeType]

SELECT * 
FROM [dbo].[AddressType]

SELECT * 
FROM [dbo].[EmailType]

SELECT * 
FROM [dbo].[PhoneType]

PRINT 'Complete'
GO