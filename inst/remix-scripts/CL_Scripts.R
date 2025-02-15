# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----
# ML Final Features Engineering      ----
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----

# ----

# ----

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----
# Admin                              ----
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----

# ----

# ----

# Admin: Command Line Defaults       ----
ProjectID <- 'Sample_Project'

# Admin: Services args               ----
Services <- c(
  'CalendarVariables',
  'HolidayVariables',
  'PartialDummies',
  'FeatureInteraction',
  'Differencing',
  'TimeSeries',
  'DataPartition',
  'Encoding') #, 'H2OWord2Vec', 'H2OAutoEncoder', 'H2OIsolationForest', 'H2OClustering')

# Admin: Path To Scripts             ----
FE_Script_Path <- file.path(system.file("remix-scripts", package = "RemixAutoML"), "Feature_Engineering.R")

# Admin: Project Directories         ----
Root_Path <- 'C:/Users/Bizon/Documents/GitHub/QA_Code/Sample_Project'
Data_Path <- file.path(Root_Path, 'Data')
MetaData_Path <- file.path(Root_Path, 'MetaData')
Model_Path <- file.path(Root_Path, 'Models')
Results_Path <- file.path(Root_Path, 'Results')
ModelType <- "Classifier"

# Data: Colnames by Type             ----
TargetVariables <- c('Adrian')
DateVariables <- c('DateTime')
GroupVariables <- if(ModelType == "MultiClass") c('Factor_2') else c('Factor_1', 'Factor_2')
ByVariables <- if(ModelType == "MultiClass") c('Factor_2') else "Factor_1"
TextVariables <- c('Comment')
IDVariables <- c('IDcol_1', 'IDcol_2')

# ----

# ----

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----
# Functions                          ----
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----

# ----

# ----

# ModelDataPrep()                    ----
Impute <- TRUE
CharToFactor <- FALSE
FactorToChar <- TRUE
IntToNumeric <- TRUE
LogicalToBinary <- TRUE
DateToChar <- FALSE
IDateConversion <- TRUE
RemoveDates <- FALSE
MissFactor <- 'missing'
MissNum <- -1
IgnoreCols <- NULL

# CreateCalendarVariables()          ----
Calendar_Variables <- c('week', 'wom', 'month', 'quarter')

# Holiday Variables
LookBackDays <- 7
Holiday_Variables <- c('USPublicHolidays', 'EasterGroup', 'ChristmasGroup', 'OtherEcclesticalFeasts')

# Partial Dummies
NumberLevels <- 3

# Interaction Variables
InteractionVariables <- c('Independent_Variable1','Independent_Variable2', 'Independent_Variable3')
InteractionDepth <- 3
InteractionCenter <- TRUE
InteractionScale <- TRUE

# Differencing
DiffVariables <- NULL
DiffDateVariables <- c('DateTime')
DiffGroupVariables <- NULL
DiffPeriods <- 3L

# AutoLagRollStats()                 ----
TimeSeriesGroupVariables <- if(ModelType == "MultiClass") 'Factor_2' else c('Factor_1,Factor_2')
TimeSeriesDateGroups <- c('days, weeks')
TimeUnitAgg <- c('weeks')
Lag_Periods <- as.character(c(1:5))
RollAverage_Periods <- as.character(c(2:5))
RollStandardDeviation_Periods <- NULL
RollSkewness_Periods <- NULL
RollKurtosis_Periods <- NULL
RollQuantiles_Periods <- NULL
RollQuantiles <- NULL

# AutoPartitionData                  ----
PartitionRatios <- as.character(c(0.70,0.20,0.10))
PartitionMethod <- 'random'
PartitionByVariables <- if(ModelType == "MultiClass") 'Factor_2' else 'Factor_1'
PartitionTimeColumnName <- 'DateTime'

# CategoricalEncoding()              ----
EncodeMethod <- c('credibility')
EncodeImpute <- 0
KeepCharColumns <- TRUE

# H2O General                        ----
H2O_Memory <- '128g'

# AutoWord2VecModeler()              ----
BuildType <- 'individual'
NumberVectors <- 20
Window <- 5
Iterations <- 20
MinWords <- 2

# H2OAutoEncoder()                   ----
AnomalyDetection <- TRUE
DimensionReduction <- TRUE
AD_PerFeature <- FALSE
RemoveBaseFeatures <- FALSE
NodeShrinkRate <- (sqrt(5) - 1) / 2
Epochs <- 20
L2 <- 0.10
ElasticAveraging <- TRUE
ElasticAveragingMovingRate <- 0.90
ElasticAveragingRegularization <- 0.001

# H2OIsolationForest()               ----
Threshold <- 0.95
NTrees <- 500
MaxDepth <- 8
MinRows <- 1
RowSampleRate <- (sqrt(5)-1)/2
ColSampleRate <- 1
ColSampleRatePerLevel <- 1
ColSampleRatePerTree <- 1

# AutoClustering()                   ----
MaxClusters <- 50
ClusterMetric <- 'totss'
Clustering_ShrinkRate <- (sqrt(5) - 1) / 2
Clustering_Epochs <- 20
Clustering_L2 <- 0.10
Clustering_ElasticAveraging <- TRUE
Clustering_ElasticAveragingMovingRate <- 0.90
Clustering_ElasticAveragingRegularization <- 0.001

# ----

# ----

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----
# Run Script                         ----
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----

# ----

# ----

# Create command line script         ----
CL_Script <- paste0(
  "Rscript --vanilla ", FE_Script_Path,
  " --Services=", paste0(Services, collapse = ","),
  " --Root_Path=", shQuote(Root_Path),
  " --Data_Path=", shQuote(Data_Path),
  " --MetaData_Path=", shQuote(MetaData_Path),
  " --Model_Path=", shQuote(Model_Path),
  " --Results_Path=", shQuote(Results_Path),
  " --ProjectID=", ProjectID,
  " --ModelType=", ModelType,
  " --TargetVariables=", paste0(gsub(pattern=' ', replacement='', x=TargetVariables), collapse = ","),
  " --DateVariables=", paste0(gsub(pattern=' ', replacement='', x=DateVariables), collapse = ","),
  " --GroupVariables=", paste0(gsub(pattern=' ', replacement='', x=GroupVariables), collapse = ","),
  " --ByVariables=", paste0(gsub(pattern=' ', replacement='', x=ByVariables), collapse = ","),
  " --TextVariables=", paste0(gsub(pattern=' ', replacement='', x=TextVariables), collapse = ","),
  " --IDVariables=", paste0(gsub(pattern=' ', replacement='', x=IDVariables), collapse = ","),
  " --InteractionVariables=", paste0(gsub(pattern=' ', replacement='', x=InteractionVariables), collapse = ","),
  " --DiffVariables=", paste0(gsub(pattern=' ', replacement='', x=DiffVariables), collapse = ","),
  " --DiffDateVariables=", paste0(gsub(pattern=' ', replacement='', x=DiffDateVariables), collapse = ","),
  " --DiffGroupVariables=", paste0(gsub(pattern=' ', replacement='', x=DiffGroupVariables), collapse = ","),
  " --Impute=", Impute,
  " --CharToFactor=", CharToFactor,
  " --FactorToChar=", FactorToChar,
  " --IntToNumeric=", IntToNumeric,
  " --LogicalToBinary=", LogicalToBinary,
  " --DateToChar=", DateToChar,
  " --IDateConversion=", IDateConversion,
  " --RemoveDates=", RemoveDates,
  " --MissFactor=", MissFactor,
  " --MissNum=", MissNum,
  " --IgnoreCols=", paste0(gsub(pattern=' ', replacement='', x=IgnoreCols), collapse = ","),
  " --Calendar_Variables=", paste0(gsub(pattern=' ', replacement='', x=Calendar_Variables), collapse = ","),
  " --LookBackDays=", LookBackDays,
  " --Holiday_Variables=", paste0(gsub(pattern=' ', replacement='', x=Holiday_Variables), collapse = ","),
  " --NumberLevels=", NumberLevels,
  " --InteractionDepth=", InteractionDepth,
  " --InteractionCenter=", InteractionCenter,
  " --InteractionScale=", InteractionScale,
  " --DiffPeriods=", DiffPeriods,
  " --TimeSeriesGroupVariables=", paste0(gsub(pattern=' ', replacement='', x=TimeSeriesGroupVariables), collapse = ","),
  " --TimeSeriesDateGroups=", paste0(gsub(pattern=' ', replacement='', x=TimeSeriesDateGroups), collapse = ","),
  " --TimeUnitAgg=", TimeUnitAgg,
  " --Lag_Periods=", paste0(gsub(pattern=' ', replacement='', x=Lag_Periods), collapse = ","),
  " --RollAverage_Periods=", paste0(gsub(pattern=' ', replacement='', x=RollAverage_Periods), collapse = ","),
  " --RollStandardDeviation_Periods=", paste0(gsub(pattern=' ', replacement='', x=RollStandardDeviation_Periods), collapse = ","),
  " --RollSkewness_Periods=", paste0(gsub(pattern=' ', replacement='', x=RollSkewness_Periods), collapse = ","),
  " --RollKurtosis_Periods=", paste0(gsub(pattern=' ', replacement='', x=RollKurtosis_Periods), collapse = ","),
  " --RollQuantiles_Periods=", paste0(gsub(pattern=' ', replacement='', x=RollQuantiles_Periods), collapse = ","),
  " --RollQuantiles=", paste0(gsub(pattern=' ', replacement='', x=RollQuantiles), collapse = ","),
  " --PartitionRatios=", paste0(gsub(pattern=' ', replacement='', x=PartitionRatios), collapse = ","),
  " --PartitionByVariables=", paste0(gsub(pattern=' ', replacement='', x=PartitionByVariables), collapse = ","),
  " --PartitionTimeColumnName=", PartitionTimeColumnName,
  " --PartitionMethod=", PartitionMethod,
  " --EncodeMethod=", EncodeMethod,
  " --EncodeImpute=", EncodeImpute,
  " --KeepCharColumns=", KeepCharColumns,
  " --H2O_Memory=", H2O_Memory,
  " --BuildType=", BuildType,
  " --NumberVectors=", NumberVectors,
  " --Window=", Window,
  " --Iterations=", Iterations,
  " --MinWords=", MinWords,
  " --AnomalyDetection=", AnomalyDetection,
  " --DimensionReduction=", DimensionReduction,
  " --AD_PerFeature=", AD_PerFeature,
  " --RemoveBaseFeatures=", RemoveBaseFeatures,
  " --NodeShrinkRate=", NodeShrinkRate,
  " --Epochs=", Epochs,
  " --L2=", L2,
  " --ElasticAveraging=", ElasticAveraging,
  " --ElasticAveragingMovingRate=", ElasticAveragingMovingRate,
  " --ElasticAveragingRegularization=", ElasticAveragingRegularization,
  " --Threshold=", Threshold,
  " --NTrees=", NTrees,
  " --MaxDepth=", MaxDepth,
  " --MinRows=", MinRows,
  " --RowSampleRate=", RowSampleRate,
  " --ColSampleRate=", ColSampleRate,
  " --ColSampleRatePerLevel=", ColSampleRatePerLevel,
  " --ColSampleRatePerTree=", ColSampleRatePerTree,
  " --MaxClusters=", MaxClusters,
  " --ClusterMetric=", ClusterMetric,
  " --Clustering_ShrinkRate=", Clustering_ShrinkRate,
  " --Clustering_Epochs=", Clustering_Epochs,
  " --Clustering_L2=", Clustering_L2,
  " --Clustering_ElasticAveraging=", Clustering_ElasticAveraging,
  " --Clustering_ElasticAveragingMovingRate=", Clustering_ElasticAveragingMovingRate,
  " --Clustering_ElasticAveragingRegularization=", Clustering_ElasticAveragingRegularization)

# Run async job                      ----
job::job(packages = c('RemixAutoML','data.table','h2o'), {
  system(CL_Script)
})


# ----

# ----

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----

