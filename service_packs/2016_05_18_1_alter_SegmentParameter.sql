-- Обновление структур таблиц
IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'SegmentParameter'
                AND column_name = 'PropertyType')
BEGIN
   ALTER TABLE [dbo].[SegmentParameter] ADD [PropertyType] [int] NULL;
   ALTER TABLE [dbo].[SegmentParameter] WITH CHECK ADD  CONSTRAINT [FK_SegmentParameter_PropertyTypes] FOREIGN KEY([PropertyType]) REFERENCES [dbo].[PropertyTypes] ([ID]);
   ALTER TABLE [dbo].[MaterialClassProperty] CHECK CONSTRAINT [FK_MaterialClassProperty_PropertyTypes];
END
GO
