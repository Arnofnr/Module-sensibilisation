# Formation "Big Data" Toulouse Tech 
# Premier regroupement
# Pascal Floquet - Florent Bourgeois 
# Universit� de Toulouse - INP-ENSIACET
# Travail sur les donn�es "ozone" 
# Data frame � partir d'un fichier csv
# path="http://www.math.univ-toulouse.fr/~besse/Wikistat/data/"

# Lecture des donn�es
ozone=read.table("ozone.csv",sep=";",dec=",",header=T)
ozone=ozone[,-1] # Suppression de la variable (inutile) "obs"

# Quelques "traitements �l�mentaires" :
#
# Valeur minimale, maximale, moyenne, m�diane et quartile
summary(ozone)
# Valeur moyenne et �cart-type
sapply(ozone[,-c(12,13)], mean)  # moyennes (des variables quantitatives)
sapply(ozone[,-c(12,13)], sd)    # �carts-types (des variables quantitatives)
# fonction d�terminant le coefficient de variation (cv = sd/mean) [%]
cv<-function(x) 100*(sd(x,na.rm=FALSE)/mean(x,na.rm=FALSE)) 
sapply(ozone[,-c(12,13)], cv)    # coefficients de variation (des variables quantitatives)

# Quelques graphiques
#
# Graphiques boites � moustaches
options(repr.plot.width=4, repr.plot.height=4) # dimensions des graphiques
boxplot(ozone[,2:4])             # bo�tes par groupe (temp�rature)
boxplot(ozone[,5:7])             # bo�tes par groupe (n�bulosit�)
boxplot(ozone[,8:10])            # bo�tes par groupe (vitesse du vent)
boxplot(ozone[,c(1,11)])         # bo�tes par groupe (concentration maximale ozone)

# Histogrammes et densit� de probabilit� (noyau)
hist(ozone$maxO3, proba=TRUE)    # concentration maximale en ozone
lines(density(ozone$maxO3),col='red',lwd=3)
hist(ozone$maxO3v,proba=TRUE)    # concentration maximale en ozone jour pr�c�dent
lines(density(ozone$maxO3v),col='red',lwd=3)
# Modification "simple" (logarithme) des variables
hist(log(ozone$maxO3), proba=TRUE)# log(concentration maximale en ozone)
lines(density(log(ozone$maxO3)),col='red',lwd=3)
hist(log(ozone$maxO3v),proba=TRUE)# log(concentration maximale en ozone jour pr�c�dent)
lines(density(log(ozone$maxO3v)),col='red',lwd=3)
boxplot(log(ozone[,c(1,11)]))    # bo�tes par groupe (log(concentration maximale ozone))
library(UsingR)
scatter.with.hist(log(ozone$maxO3),log(ozone$maxO3v))
# Graphiques en barres et secteurs
barplot(table(ozone$pluie))
barplot(table(ozone$vent))
pie(table(ozone$vent))

#Matrice de corr�lations
options(repr.plot.width=8, repr.plot.height=8) # dimensions 
pairs(ozone[,1:11])

# Graphes nuage de points (scatter plot)
options(repr.plot.width=4, repr.plot.height=4) # dimensions
plot(maxO3~maxO3v,data=ozone)
plot(log(maxO3)~log(maxO3v),data=ozone)

# Tableau de contingence et graphiques
table(ozone$vent,ozone$pluie)
mosaicplot(table(ozone$vent,ozone$pluie))
boxplot(maxO3~pluie,data=ozone)
boxplot(maxO3~vent,data=ozone)

# qq-plots et test de normalit�
qqnorm(ozone$maxO3)
qqline(ozone$maxO3,col=2)
qqnorm(log(ozone$maxO3))
qqline(log(ozone$maxO3),col=2)
shapiro.test(ozone$maxO3) # Test de Shapiro-Wilks
shapiro.test(log(ozone$maxO3))

# Ajout des variables log(Max O3) et log(Max O3 v)
ozone=data.frame(ozone,LmaxO3=log(ozone$maxO3),LmaxO3v=log(ozone$maxO3v))
summary(ozone)
shapiro.test(ozone[ozone$pluie=="Pluie","LmaxO3"]) # Log(MaxO3) avec modalit� Pluie
shapiro.test(ozone[ozone$pluie=="Sec","LmaxO3"])   # Log(MaxO3) avec modalit� Sec

# Test nullit� moyenne LmaxO3, ind�pendance et �galit� moyenne MaxO3 et MaxO3v
t.test(ozone$LmaxO3, conf.level=.95) #intervalle de confiance
chisq.test(ozone$maxO3, ozone$maxO3v)
t.test(ozone$maxO3,ozone$maxO3v)
t.test(ozone$maxO3, ozone$maxO3v,paired=TRUE)

# Test �galit� des moyennes et des variances (test de Fisher)
t.test(LmaxO3~pluie,data=ozone)
var.test(LmaxO3~pluie,data=ozone)
tapply(ozone$LmaxO3, ozone$pluie, median)

# Ind�pendance pluie/vent
chisq.test(table(ozone$pluie,ozone$vent))

# ANOVA � un facteur
# estimation des param�tres
res.anova=aov(LmaxO3 ~ vent, data=ozone)
summary(res.anova)

# Graphique nuage de points
plot(LmaxO3 ~ LmaxO3v,data=ozone)
# R�gression lin�aire estimation du mod�le
res1.reg=lm(LmaxO3 ~ LmaxO3v, data = ozone)
# liste des r�sultats et r�sultats
names(res1.reg)
summary(res1.reg)
# rep�rage des points influents
res.student=rstudent(res1.reg)
ychap=res1.reg$fitted.values
cook=cooks.distance(res1.reg)
plot(cook~ychap,ylab="Distance de Cook")
# normalit� des r�sidus
qqnorm(res1.reg$residuals)
qqline(res1.reg$residuals)
shapiro.test(res1.reg$residuals)

# R�gression lin�aire estimation du mod�le
res2.reg=lm(LmaxO3 ~ T12+Ne12+Vx12, data = ozone)
plot(res2.reg)
summary(res2.reg)



