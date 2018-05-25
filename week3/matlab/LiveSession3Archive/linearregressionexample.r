#Load Train and Test datasets
train = read.csv('population_accidents_training.csv')
test = read.csv('population_accidents_testing.csv')
print(summary(train))  
print(summary(test))  

#x <- data.frame(cbind(train$x_train,train$y_train))
x_test <- data.frame(x_train=test$x_test)

# Train the model using the training sets and check score
linear <- lm(y_train ~ x_train, data = train)
summary(linear)

#Predict Output
y_predicted_test=predict(linear,newdata= x_test) 

# Give the chart file a name.
png(file = "linearregression-r.png")

# Plot the data.
plot(train$x_train, train$y_train,col = "blue",main = "Population & Accidents Regression",
cex = 1.3,pch = 16,xlab = "Population",ylab = "Accidents")
points(test$x_test, test$y_test,col = "red",cex = 1.3,pch = 16)
abline(linear, col="darkgreen",lwd=3)
grid (10,10, lty = 6, col = "cornsilk2")
#legend("bottomright", c("Training Data","Test Data","Fit"), inset=.05, lty=1:2, cex=0.8)
  	
# Save the plot file.
dev.off()
