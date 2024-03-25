use MickeyMouseA06
Go
Drop Procedure If Exists PR_Update_MickeyMouseGrade_Try_Catch
Go
Create Procedure PR_Update_MickeyMouseGrade_Try_Catch
	(@StudentID decimal(8,0) = null, @CourseID Char(8) = null, @Mark Decimal(5,2) = null)
As
Begin
	If @StudentID is null or @CourseID is null or @Mark is null
		Begin
			RaisError('You must provide a Student ID, Course ID and Mark', 16, 1)
		End
	Else
		Begin
			Begin Try
				Update	MickeyMouseGrade
				Set		Mark = @Mark
				Where	StudentID = @StudentID and
						CourseID = @CourseID
			End Try
			-- nothing can be between the end of the Try block and the beginning of the Catch block
			Begin Catch
				-- Note: If Throw is not the first statement in the Catch block, the preceding statement must end with a semicolon
				-- 50000 is an arbitrary error number, but it is the same as the default RaisError error number
				Throw 50000, 'Update of MickeyMouseGrade failed.', 1;
				-- If you want to capture and display the actual SQL Server error message, use the following code:
--				Declare @ErrorMessage Varchar(2048);
--				Select @ErrorMessage = Error_Message(); 
--				Throw 50000, @ErrorMessage, 1;
				
				-- To append the actual SQL Server message to your error message
				 --Declare @ErrorMessage Varchar(2048);
				 --Declare @MyErrorMessage Varchar(2500);
				 --Select @ErrorMessage = Error_Message();
				 --Select @MyErrorMessage = 'Update of MickeyMouseGrade failed. ' + @ErrorMessage;
				 --Throw 50000, @MyErrorMessage, 1;

			End Catch
		End
End
Return
Go