#-----
# Borrar objetos
# --------------
rm(list=ls(all=TRUE))

# Direccionar carpeta de procesos
# -------------------------------
# getwd() # actual ubicacion
# setwd("C:/Users/marcelo.sanmartin/Personal/IFOP/Congresos/IFOMC2023")


###############--------------Luego de llamar los analisis se corren las figuras----------------#################
# ----------------
library(readxl)
require(plyr)
#require(reshape)
require(reshape2)
library(tidyverse)
library(lubridate)

#Probando mapas por a�o
library(readxl)
library(car)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(plyr)
library(readr)
library(dplyr)
library(maps)
library(ggthemes)
library(sf)
library(maptools)


desc<-read_excel("Descartes_hist.xlsx", sheet ="desc_13_20")
rate_aves<-read_excel("Res_CI_tasas.xlsx", sheet ="Aves_rate")
rate_mam<-read_excel("Res_CI_tasas.xlsx", sheet ="Mam_rate")

head(desc)
cbind(names(desc))

##-Descarte por flota
#-Hacer el formato largo de la base, as� no es necesario transformarlo en data frame. Si convierto antes a dataframe le
#-le pone una X antes del a�o.

desc.long<-melt(desc,id.vars=c(1),measure.vars=c(2:9),variable.name = "A�o",
          value.name = "Proporci�n")#cap_total es la cpue estandarizada

head(desc.long)

pd <- position_dodge(0.5)
graf2<-ggplot(desc.long, aes(x=as.factor(A�o), y=Proporci�n, group=Fleet, colour=Fleet)) +      
  geom_point(size=3,position=pd) + geom_line()+
  #geom_point(size=3,position=pd) + geom_line(arrow = arrow(),lwd=1)+
  #geom_errorbar(aes(ymin=l.lim, ymax=u.lim),linewidth=0.5, width=.1,position=pd)+
  labs(x="A�o",
       y="Proporci�n descarte (%)",
       #title= "Estimaci�n Total  crust�ceos",
       subtitle="Descarte total",
       caption="Programa de Investigaci�n Descarte Demersal",
       tag = "T: Trawling; L: Longline") +theme_bw()+
  scale_x_discrete(breaks =seq(2013,2020,1))+
  scale_y_continuous(limit = c(0,40),breaks=seq(0,40,10))+
  #facet_grid(~Proporci�n)
  facet_wrap(~Fleet,ncol=2)

win.graph(width=8000, height=6000,pointsize=10)
graf2+theme(legend.position = "none", plot.tag.position = c(0.7, 0.2), plot.margin=unit(c(1,1,1,1), "cm"))

##-Tasas de capturas incidentales de aves
head(rate_aves)
cbind(names(rate_aves))

rate_aves.long<-melt(rate_aves,id.vars=c(1),measure.vars=c(2:7),variable.name = "A�o",
                value.name = "Tasa")#cap_total es la cpue estandarizada

head(rate_aves.long)

pd <- position_dodge(0.5)
graf3<-ggplot(rate_aves.long, aes(x=as.factor(A�o), y=Tasa, group=Fleet, colour=Fleet)) +      
  geom_point(size=3,position=pd) + geom_line(arrow = arrow(),lwd=1)+
  #geom_point(size=3,position=pd) + geom_line()+
  #geom_errorbar(aes(ymin=l.lim, ymax=u.lim),linewidth=0.5, width=.1,position=pd)+
  labs(x="A�o",
       y="Rate (N�*set (T) - N�*1000 hoock (L))",
       #title= "Estimaci�n Total  crust�ceos",
       subtitle="Aves marinas",
       caption="Programa de Investigaci�n Descarte Demersal",
       tag = "T: Trawling; L: Longline") +theme_bw()+
  scale_x_discrete(breaks =seq(2015,2020,1))+
  #scale_y_continuous(limit = c(0,1),breaks=seq(0,1,0.01))+
  #facet_grid(~Proporci�n)
  facet_wrap(~Fleet,ncol=2, scales =  "free")

win.graph(width=8000, height=6000,pointsize=10)
graf3+theme(legend.position = "none", plot.tag.position = c(0.7, 0.2), plot.margin=unit(c(1,1,1,1), "cm"))


##-Tasas de capturas incidentales de mam�feros
head(rate_mam)
cbind(names(rate_mam))

rate_mam.long<-melt(rate_mam,id.vars=c(1),measure.vars=c(2:8),variable.name = "A�o",
                     value.name = "Tasa")#cap_total es la cpue estandarizada

head(rate_mam.long)

pd <- position_dodge(0.5)
graf4<-ggplot(rate_mam.long, aes(x=as.factor(A�o), y=Tasa, group=Fleet, colour=Fleet)) +      
  #geom_point(size=3,position=pd) + geom_line(arrow = arrow(),lwd=1)+
  geom_point(size=3,position=pd) + geom_line()+
  #geom_errorbar(aes(ymin=l.lim, ymax=u.lim),linewidth=0.5, width=.1,position=pd)+
  labs(x="A�o",
       y="Rate (N�*set)",
       #title= "Estimaci�n Total  crust�ceos",
       subtitle="Mam�feros marinos",
       caption="Programa de Investigaci�n Descarte Demersal",
       tag = "T: Trawling") +theme_bw()+
  scale_x_discrete(breaks =seq(2015,2021,1))+
  #scale_y_continuous(limit = c(0,1),breaks=seq(0,1,0.01))+
  #facet_grid(~Proporci�n)
  facet_wrap(~Fleet,ncol=2, scales =  "free")

win.graph(width=8000, height=6000,pointsize=10)
graf4+theme(legend.position = "none", plot.tag.position = c(0.7, 0.2), plot.margin=unit(c(1,1,1,1), "cm"))




####################################----0----################################################








#Seleccionando algunas sp a graficar 
lista.aux<-lista_sp2.2.long[lista_sp2.2.long$Sp%in%c(1,35,135,136),]
head(lista.aux)

##Figura capturas hist�ricas 1993-2018...CAMBIAR TITULO DE LEYENDA E INSERTAR A�OS QUE NO SE HIZO CRUCERO
library(plotly)
win.graph(width=1000, height=500,pointsize=10)
#tasas estimada survey
ggplot(lista.aux, aes(x=a�o, y=cap_total, group=NOMBRE_COMUN, colour=NOMBRE_COMUN)) +#, shape=NOMBRE_COMUN
  geom_point(size = 3) + #ylim(0, 0.600) + 
  geom_line(aes(), size = 1) + 
  #scale_color_discrete(name='Etiquetas') +
  theme(text = element_text(size = 14, family = "Tahoma"),
        axis.title = element_text(face="bold",size=14),
        #axis.text.x=element_text(size=14),
        axis.text.x = element_text(angle = 90, hjust = 1))+#,axis.text.y=element_text(size = 14))+
  scale_color_discrete(name = "Especie")+
  #scale_y_continuous(labels= scales::number_format(accuracy = 0.001),breaks=seq(0, 1,0.1))+
  ylab("Catch (t)")+xlab("Year")+
  # #theme(legend.title = element_text(colour="black", size=14, face="bold"))+
  # #theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  # facet_wrap(A�O~Estrato,scales = "free",ncol=3) + labs(y = 'Tasa (ind/lance)', x = 'Estimador',z="")+
  # #facet_grid(Estimador~Estrato,scales = "free") + labs(y = 'Tasa (ind/lance)', x = 'Estrato',z="")+
  theme_bw()

##--Haciendo la figura pero con las tasas de captura media por lance de cada sp para cada a�o 
##Uso la base maestra con todas las sp en formato largo "dc3" para agrupar al a�o
lista.sp.cap.mean <- ddply(dc3,c("a�o","Sp"),
                  summarise,
                  cap_total=mean(cpue_ton)
)

##tambien se puede ver con un tapply de data.cluster.cpue2 (formato ancho) para probar que qued� bien (ok)
#tapply(data.cluster.cpue2$"6",data.cluster.cpue2$a�o%in%c(1995),mean)

#todos los a�os tienen la misma cantidad de sp.
table(lista.sp.cap.mean$Sp,lista.sp.cap.mean$a�o,exclude=NULL)

###---
##Filtrando para ver tendencias de las capturas medias de cada sp por lance en cada a�o. 
#Se seleccionan las sp representativas. Se usara el mismo objeto lista.aux
lista.aux<-lista.sp.cap.mean[lista.sp.cap.mean$Sp%in%c(1,35,48,135,136),]
head(lista.aux)

win.graph(width=1000, height=500,pointsize=10)
#tasas estimada survey
ggplot(lista.aux, aes(x=a�o, y=cap_total, group=Sp, colour=Sp)) +#, shape=NOMBRE_COMUN
  geom_point(size = 3) + #ylim(0, 0.600) + 
  geom_line(aes(), size = 1) + 
  #scale_color_discrete(name='Etiquetas') +
  theme(text = element_text(size = 14, family = "Tahoma"),
        axis.title = element_text(face="bold",size=14),
        #axis.text.x=element_text(size=14),
        axis.text.x = element_text(angle = 90, hjust = 1))+#,axis.text.y=element_text(size = 14))+
  scale_color_discrete(name = "Especie")+
  #scale_y_continuous(labels= scales::number_format(accuracy = 0.001),breaks=seq(0, 1,0.1))+
  ylab("Mean catch by lance (t)")+xlab("Year")+
  theme_bw()

###filtrando para ver tendencias de las capturas medias de cada sp por lance en cada a�o, cluster.
lista.sp.cap.mean <- ddply(dc3,c("a�o","C2","Sp"),
                           summarise,
                           cap_total=mean(cpue_ton)
)

#Ahora filtrando seg�n cluster, probando cluster 1 y 6 (criterio 2). Se seleccionan las sp representativas
lista.aux<-lista.sp.cap.mean[lista.sp.cap.mean$Sp%in%c(1,35,48,135,136),]
head(lista.aux)

###-1-Esta forma permite hacer cambios en las etiquetas de ejes, tama�os letras, etc. 
p<-ggplot(lista.aux, aes(x=a�o, y=cap_total, group=Sp, colour=Sp)) +#, shape=NOMBRE_COMUN
  geom_point(size = 1) + #ylim(0, 0.600) + 
  geom_line(aes(group=Sp), size = 1) + 
  scale_x_continuous(limit = c(1993,2018), breaks=seq(1993, 2018, 1))+
  theme_bw()
win.graph(width=1000, height=1000,pointsize=11) 

p+facet_wrap(~C2,ncol=1) +
  #scale_color_discrete(name='Etiquetas') +
  theme (axis.text.x = element_text(colour="black", size=11, angle=90),
         axis.text.y = element_text(colour="black", size=11, angle=0, hjust=0.5),
         #legend.position="bottom",strip.text.x = element_text(size = 11, colour = "black"),
         strip.text.y = element_text(size = 12, colour = "black",face="italic"))+
  scale_color_discrete(name = "Especie")+      
  #scale_y_continuous(labels= scales::number_format(accuracy = 0.001),breaks=seq(0, 1,0.1))+
  ylab("Mean catch by lance (t)")+xlab("Year")

###-2-otra para cambiar las formas de los puntos
p<-ggplot(lista.aux, aes(x=a�o, y=cap_total, group=Sp, colour=Sp,shape=Sp)) #, shape=NOMBRE_COMUN
  p <- p + scale_shape_manual(values = 0:length(unique(lista.aux$Sp)))
  p<-p+ geom_point(size = 1) #ylim(0, 0.600) + 
  p<-p+ geom_line(aes(group=Sp), size = 1) 
  p<-p+scale_x_continuous(limit = c(1993,2018), breaks=seq(1993, 2018, 1))
  p<-p+ theme_bw()
win.graph(width=1000, height=1000,pointsize=11) 

p+facet_wrap(~C2,ncol=1) +
  #scale_color_discrete(name='Etiquetas') +
  theme (axis.text.x = element_text(colour="black", size=11, angle=90),
         axis.text.y = element_text(colour="black", size=11, angle=0, hjust=0.5),
         #legend.position="bottom",strip.text.x = element_text(size = 11, colour = "black"),
         strip.text.y = element_text(size = 12, colour = "black",face="italic"))+
  #scale_color_discrete(name = "Especie")+      
  #scale_y_continuous(labels= scales::number_format(accuracy = 0.001),breaks=seq(0, 1,0.1))+
  ylab("Mean catch by lance (t)")+xlab("Year")

###-3-Otra forma m�s flexible la de arriba 
win.graph(width=900, height=700,pointsize=10)
#tasas estimada survey
ggplot(lista.aux, aes(x=a�o, y=cap_total, group=Sp, colour=Sp)) +#, shape=NOMBRE_COMUN
  geom_point(size = 3) + #ylim(0, 0.600) + 
  geom_line(aes(), size = 1) + 
  scale_x_continuous(limit = c(1993,2018), breaks=seq(1993, 2018, 1))+
  facet_wrap(~C2,ncol=1)+ 
  #scale_color_discrete(name='Etiquetas') +
  theme(text = element_text(size = 14, family = "Tahoma"),
        axis.title = element_text(face="bold",size=14),
        #axis.text.x=element_text(size=14),
        axis.text.x = element_text(angle = 90, size=8))+#,axis.text.y=element_text(size = 14))+
  scale_color_discrete(name = "Especie")+
  #scale_y_continuous(labels= scales::number_format(accuracy = 0.001),breaks=seq(0, 1,0.1))+
  ylab("Mean catch by lance (t)")+xlab("Year")+
  theme_bw()
####################################################################### 

#######################################################################
#####---Sacando figuras de participaci�n de cluster por a�o (considera la suma de cpue de cada cluster)---#####

##-Primero agrupo de una base total (uso la base dc4.res2, agrupada a nivel de especie dentro de cada cluster y a�o)
participacion.cluster <- ddply(dc4.res2,c("a�o","C2"),
                  summarise,
                  cpue.total=sum(cpue),
                  Merluza=sum(cpue[Sp=="1"]),
                  Jibia=sum(cpue[Sp=="35"]),
                  Otras=sum(cpue[!Sp%in%c("1","35")]))

#Merluza=min(cpue[which(Sp=="1")]),
head(participacion.cluster)
sum(participacion.cluster[1,c(4:6)])

# merluza<-dc4.res2[dc4.res2$Sp=="1",]
# head(merluza[order(merluza$a�o,merluza$C2),],10)
# 
# jibia<-dc4.res2[dc4.res2$Sp=="35",]
# head(jibia[order(jibia$a�o,jibia$C2),],10)
##
# dc4.res2[dc4.res2$a�o==1993 & dc4.res2$C2==1,]
#

##--Resumen anual para sacar el peso total por a�o
participacion.cluster2 <- ddply(dc4.res2,c("a�o"),
                               summarise,
                               cpue.TOTAL.a�o=sum(cpue),
                               Merluza.TOTAL.a�o=sum(cpue[Sp=="1"]),
                               Jibia.TOTAL.a�o=sum(cpue[Sp=="35"]),
                               Otras.TOTAL.a�o=sum(cpue[!Sp%in%c("1","35")]))

head(participacion.cluster2)
sum(participacion.cluster2[1,c(3:5)])

##--Uniendo participacion.cluster y el dato de cpue.TOTAL por a�o de participacion.cluster2--##
participacion.cluster3 <- merge(participacion.cluster,participacion.cluster2[,c("a�o","cpue.TOTAL.a�o","Merluza.TOTAL.a�o",
                                "Jibia.TOTAL.a�o","Otras.TOTAL.a�o")],
                            by.x=c("a�o"),by.y=c("a�o"))

head(participacion.cluster3)

##--Sacando proporciones y contribuci�n de cada lance en cada a�o--##
participacion.cluster3$pp.cluster<-round((participacion.cluster3$cpue.total/participacion.cluster3$cpue.TOTAL.a�o)*100,2)
participacion.cluster3$pp.merluza.cluster<-round((participacion.cluster3$Merluza/participacion.cluster3$Merluza.TOTAL.a�o)*100,2)
participacion.cluster3$pp.jibia.cluster<-round((participacion.cluster3$Jibia/participacion.cluster3$Jibia.TOTAL.a�o)*100,2)
participacion.cluster3$pp.otras.cluster<-round((participacion.cluster3$Otras/participacion.cluster3$Otras.TOTAL.a�o)*100,2)

sum(participacion.cluster3[c(1:4),11])

win.graph(width=22000, height=12000,pointsize=10)
ggplot(participacion.cluster3,aes(x=a�o, y = pp.cluster,fill = C2)) + 
  scale_x_continuous(limit = c(1993,2018), breaks=seq(1993, 2018, 1))+
  #facet_wrap(~a�o) +
  geom_bar(stat = "identity",aes(fill = C2))+
  #geom_bar(stat = "identity",aes(fill = sigla_cientifico), colour='black')+
  labs(x = "Year", y = "Proportion", fill = "Cluster")

win.graph(width=22000, height=12000,pointsize=10)
ggplot(participacion.cluster3,aes(x=a�o, y = pp.cluster,fill = factor(C2))) + 
  scale_x_continuous(limit = c(1992,2019), breaks=seq(1992, 2019, 1))+
  scale_y_continuous(limit = c(0,100), breaks=seq(0, 100, 20))+
  #facet_wrap(~a�o) +
  geom_bar(stat = "identity", width = 0.7)+
  #geom_bar(stat = "identity",aes(fill = sigla_cientifico), colour='black')+
  labs(x = "Year", y = "Proportion", fill = "Cluster")+
  theme_bw()

ggplot(participacion.cluster3, aes(x = a�o, y = pp.cluster, fill = factor(C2))) +
  geom_bar(stat="identity", width = 0.7) +
  scale_x_continuous(limit = c(1992,2019), breaks=seq(1993, 2018, 1)) +
  scale_y_continuous(breaks=seq(0, 100, 20))+
  labs(x = "Year", y = "Proportion", fill = "Cluster") +
  theme_minimal(base_size = 12)+
  theme_bw()


win.graph(width=1000, height=500,pointsize=10)
ggplot(participacion.cluster3, aes(x = a�o, y = pp.cluster)) +
  geom_bar(stat = "identity",aes(fill = factor(C2))) + 
  xlab("Year") + ylab("Proportion") + ggtitle("") +
  # grey_theme + geom_jitter(width = 0.2)+ #+ coord_flip()  #coord_flip cambia la posici�n de los ejes
  #facet_grid(.~Estimador1) + labs(y = 'Porcentaje (%)', x = 'A�o',z="Barco")+
  #facet_grid(Estimador2~Flota2) + labs(y = 'Porcentaje (%)', x = 'A�o',z="Barco")+
  #theme(legend.position="right", legend.title="Estado de captura")
  theme(legend.position="bottom")+
  scale_fill_discrete(name = "Cluster")+
  #scale_fill_manual("Estado de captura", values = c("Vivo" = "blue", "Muerto" = "red"))+
  scale_x_continuous(limit = c(1992,2019), breaks=seq(1993, 2018, 1)) +
  scale_y_continuous(breaks=seq(0, 100, 20))+
  #stat_summary(fun.y = "mean", geom = "point", shape = 8, size = 2, color = "red")
  theme_bw()

# con peso
win.graph(width=1000, height=500,pointsize=10)
ggplot(participacion.cluster3, aes(x = a�o, y = cpue.total)) +
  geom_bar(stat = "identity",aes(fill = factor(C2))) + 
  xlab("Year") + ylab("Catch (t)") + ggtitle("") +
  # grey_theme + geom_jitter(width = 0.2)+ #+ coord_flip()  #coord_flip cambia la posici�n de los ejes
  #facet_grid(.~Estimador1) + labs(y = 'Porcentaje (%)', x = 'A�o',z="Barco")+
  #facet_grid(Estimador2~Flota2) + labs(y = 'Porcentaje (%)', x = 'A�o',z="Barco")+
  #theme(legend.position="right", legend.title="Estado de captura")
  theme(legend.position="bottom")+
  scale_fill_discrete(name = "Cluster")+
  #scale_fill_manual("Estado de captura", values = c("Vivo" = "blue", "Muerto" = "red"))+
  scale_x_continuous(limit = c(1992,2019), breaks=seq(1992,2019, 1)) +
  scale_y_continuous(limit = c(0,800),breaks=seq(0, 800, 100))+
  #stat_summary(fun.y = "mean", geom = "point", shape = 8, size = 2, color = "red")
  theme_bw()


#######################################################################
##--Determinando la importancia de cada sp en cada cluster y a�o
##--El dato lo tiene la base dc4.res2
#Probando si la proporci�n de sp en cada cluster-a�o da 1
sum(dc4.res2[dc4.res2$a�o==1993 & dc4.res2$C2==1,][,6])# Ok

prop.sp.clust.year<-dc4.res2[order(dc4.res2$a�o,dc4.res2$C2,-dc4.res2$prop.cpue.Sp),]


prop.sp.clust.year[prop.sp.clust.year$a�o==1993 & prop.sp.clust.year$C2==1,]

#Generando bases por cada cluster para graficar
prop.sp.clust.year.C1<-prop.sp.clust.year[prop.sp.clust.year$C2==1,]
prop.sp.clust.year.C2<-prop.sp.clust.year[prop.sp.clust.year$C2==2,]
prop.sp.clust.year.C3<-prop.sp.clust.year[prop.sp.clust.year$C2==3,]
prop.sp.clust.year.C4<-prop.sp.clust.year[prop.sp.clust.year$C2==4,]
prop.sp.clust.year.C5<-prop.sp.clust.year[prop.sp.clust.year$C2==5,]
prop.sp.clust.year.C6<-prop.sp.clust.year[prop.sp.clust.year$C2==6,]

win.graph(width=1000, height=500,pointsize=10)
#Cambiar cluster seg�n corresponda
p<-ggplot(prop.sp.clust.year.C6, aes(x = Sp, y = cpue)) + #cambiar por prop.cpue.Sp o cpue, seg�n se requiera. 
  geom_bar(stat = "identity",aes(fill = Sp)) + 
  #xlab("Year") + ylab("Proportion (%)") + ggtitle("Proportion cluster 1") + #cambiar n�mero de cluster seg�n corresponda
  xlab("Year") + ylab("Catch (ton)") + ggtitle("Catch cluster 6") +
  # grey_theme + geom_jitter(width = 0.2)+ #+ coord_flip()  #coord_flip cambia la posici�n de los ejes
  facet_wrap(~a�o, nrow = 4) + #labs(y = 'Proportion (%)', x = 'Year',z="Barco")+
  #facet_grid(Estimador2~Flota2) + labs(y = 'Porcentaje (%)', x = 'A�o',z="Barco")+
  #theme(legend.position="right", legend.title="Estado de captura")
  #theme(legend.position="bottom")+
  #scale_fill_discrete(name = "Cluster")+
  #scale_fill_manual("Estado de captura", values = c("Vivo" = "blue", "Muerto" = "red"))+
  #scale_x_discrete() +
  #scale_y_continuous(limit = c(0,1),breaks=seq(0, 1, 0.2))+ #para proporciones
  scale_y_continuous(limit = c(0,160),breaks=seq(0, 160, 20))+#para capturas
  #stat_summary(fun.y = "mean", geom = "point", shape = 8, size = 2, color = "red")
  theme_bw()

p+#facet_wrap(~C2,ncol=1) +
  #scale_color_discrete(name='Etiquetas') +
  theme (axis.text.x = element_text(colour="black", size=6, angle=90, hjust=1,vjust = 0.5),
         axis.text.y = element_text(colour="black", size=8, angle=0, hjust=0.5),
         legend.position="right",strip.text.x = element_text(size = 11, colour = "black"),
         strip.text.y = element_text(size = 8, colour = "black",face="italic"))+
  #scale_color_discrete(name = "Especie")
  guides(fill=guide_legend(title="Especie"))
  #scale_y_continuous(labels= scales::number_format(accuracy = 0.001),breaks=seq(0, 1,0.1))+
 # ylab("Mean catch by lance (t)")+xlab("Year")

#Otra forma
ggplot(prop.sp.clust.year.C1, aes(fill=Sp, y=prop.cpue.Sp, x=Sp)) + 
  geom_bar(position="dodge", stat="identity")+
  facet_wrap(~a�o)


#######################################################################
##--revisando que especies son importantes en cada a�o
imp.relativa.sp <- ddply(dc4.res2,c("a�o","Sp"),
                                summarise,
                                cpue.TOTAL=sum(cpue))
                                # Merluza.TOTAL=sum(cpue[Sp=="1"]),
                                # Jibia.TOTAL=sum(cpue[Sp=="35"]))

imp.relativa.sp2 <- ddply(dc4.res2,c("a�o"),
                         summarise,
                         CPUE.TOTAL=sum(cpue),
                         n.sp=length(unique(Sp[cpue>0])))

imp.relativa.sp3 <- merge(imp.relativa.sp,imp.relativa.sp2[,c("a�o","CPUE.TOTAL","n.sp")],
                                by.x=c("a�o"),by.y=c("a�o"))

imp.relativa.sp3$pp.SP<-round((imp.relativa.sp3$cpue.TOTAL/imp.relativa.sp3$CPUE.TOTAL)*100,2)

head(imp.relativa.sp3,22)
sum(imp.relativa.sp3[c(1:20),6])


##--Sacando figura de participaci�n de Sp por a�o--##
#-Opci�n 1
win.graph(width=2000, height=1500,pointsize=10)
#tasas estimada survey
ggplot(imp.relativa.sp3, aes(x=Sp, y=pp.SP, fill=Sp)) +#, shape=NOMBRE_COMUN
  #geom_col() + #ylim(0, 0.600) + 
  geom_bar(stat = "identity", position = "dodge") +
  #geom_line(aes(), size = 1) + 
  #scale_x_continuous(limit = c(1993,2018), breaks=seq(1993, 2018, 1))+
  facet_wrap(~a�o,ncol=3)+ 
  #scale_color_discrete(name='Etiquetas') +
  theme(text = element_text(size = 8, family = "Tahoma"),
        axis.title = element_text(face="bold",size=8),
        #axis.text.x=element_text(size=14),
        axis.text.x = element_text(angle = 90, size=3))+#,axis.text.y=element_text(size = 14))+
  scale_color_discrete(name = "Especie")+
  #scale_y_continuous(labels= scales::number_format(accuracy = 0.001),breaks=seq(0, 1,0.1))+
  ylab("Mean catch by lance (t)")+xlab("Year")+
  theme_bw()

#-Opci�n 2
graph<-ggplot(imp.relativa.sp3, aes(Sp, pp.SP))+ #se puede cambiar la pp.SP por cpue.TOTAL
  geom_bar(stat = "identity",aes(fill = Sp)) +#fill="blue"
  facet_grid(~a�o)+xlab("Specie")+ylab("Proportion")+ggtitle("")+
  scale_y_continuous(limit = c(0,100),breaks=seq(0, 100, 20))+
  scale_fill_discrete(guide = guide_legend(title = "Specie"))
graph2 = graph + #theme_bw()+

theme(legend.key.size=unit(1,"mm"),
      legend.text=element_text(size=8),
      legend.title=element_text(size=8),
      axis.text.x = element_blank(),#element_text(colour="black", size=4)
      axis.ticks.x=element_blank(),
      axis.text.y = element_text(colour="black", size=8, angle=0, hjust=1),
      strip.text.y = element_text(size = 8, colour = "black",face="italic"))

win.graph(width=2000, height=1000,pointsize=10)
graph2

#-Opci�n 3
p<-ggplot(imp.relativa.sp3, aes(x=a�o, y=cpue.TOTAL, group=Sp, colour=Sp,shape=Sp)) #, shape=NOMBRE_COMUN
p <- p + scale_shape_manual(values = 0:length(unique(imp.relativa.sp3$Sp)))
p<-p+ geom_point(size = 1) #ylim(0, 0.600) + 
p<-p+ geom_line(aes(group=Sp), size = 1) 
p<-p+scale_x_continuous(limit = c(1993,2018), breaks=seq(1993, 2018, 1))
p<-p+scale_y_continuous(limit = c(0,800), breaks=seq(0,600, 200))
p<-p+ theme_bw()
win.graph(width=2200, height=1200,pointsize=11) 

p+facet_wrap(~Sp,ncol=4) +
  #scale_color_discrete(name='Etiquetas') +
  theme (axis.text.x = element_text(colour="black", size=7, angle=90),
         axis.text.y = element_text(colour="black", size=7, angle=0, hjust=0.5),
         #legend.position="bottom",strip.text.x = element_text(size = 11, colour = "black"),
         strip.text.y = element_text(size = 10, colour = "black",face="italic"))+
  #scale_color_discrete(name = "Especie")+      
  #scale_y_continuous(labels= scales::number_format(accuracy = 0.001),breaks=seq(0, 1,0.1))+
  ylab("Catch (ton)")+xlab("Year")




##