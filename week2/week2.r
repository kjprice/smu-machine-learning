data("iris")
dim(iris)
head(iris)
y = iris$Sepal.Length
width = iris$Sepal.Width
species = iris$Species

fit = glm(y~width+species:width)
summary(fit)
coef(fit)
