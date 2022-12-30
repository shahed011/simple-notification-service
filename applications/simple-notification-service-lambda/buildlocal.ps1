cd src/Simple.Notification.Service.Lambda
dotnet restore
dotnet clean
dotnet build
dotnet lambda package -c Release -o ../../simple-notification-service-lambda.zip -f net6.0
cd..
cd..