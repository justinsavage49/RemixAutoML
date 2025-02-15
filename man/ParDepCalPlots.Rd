% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ModelEvaluationPlots.R
\name{ParDepCalPlots}
\alias{ParDepCalPlots}
\title{ParDepCalPlots}
\usage{
ParDepCalPlots(
  data,
  PredictionColName = NULL,
  TargetColName = NULL,
  IndepVar = NULL,
  GraphType = "calibration",
  PercentileBucket = 0.05,
  FactLevels = 10,
  Function = function(x) mean(x, na.rm = TRUE),
  DateColumn = NULL,
  DateAgg_3D = NULL,
  PlotYMeanColor = "black",
  PlotXMeanColor = "chocolate",
  PlotXLowColor = "purple",
  PlotXHighColor = "purple"
)
}
\arguments{
\item{data}{Data containing predicted values and actual values for comparison}

\item{PredictionColName}{Predicted values column names}

\item{TargetColName}{Target value column names}

\item{IndepVar}{Independent variable column names}

\item{GraphType}{calibration or boxplot - calibration aggregated data based on summary statistic; boxplot shows variation}

\item{PercentileBucket}{Number of buckets to partition the space on (0,1) for evaluation}

\item{FactLevels}{The number of levels to show on the chart (1. Levels are chosen based on frequency; 2. all other levels grouped and labeled as "Other")}

\item{Function}{Supply the function you wish to use for aggregation.}

\item{DateColumn}{Add date column for 3D scatterplot}

\item{DateAgg_3D}{Aggregate date column by 'day', 'week', 'month', 'quarter', 'year'}
}
\value{
Partial dependence calibration plot or boxplot
}
\description{
This function automatically builds partial dependence calibration plots and partial dependence calibration boxplots for model evaluation using regression, quantile regression, and binary and multinomial classification
}
\examples{
\dontrun{
# Create fake data
data <- RemixAutoML::FakeDataGenerator(
  Correlation = 0.70, N = 10000000, Classification = FALSE)
data.table::setnames(data, "Independent_Variable2", "Predict")

# Build plot
Plot <- RemixAutoML::ParDepCalPlots(
  data,
  PredictionColName = "Predict",
  TargetColName = "Adrian",
  IndepVar = "Independent_Variable1",
  GraphType = "calibration",
  PercentileBucket = 0.20,
  FactLevels = 10,
  Function = function(x) mean(x, na.rm = TRUE),
  DateColumn = NULL,
  DateAgg_3D = NULL)

# Step through function
# PredictionColName = "Predict"
# TargetColName = "Adrian"
# IndepVar = "Independent_Variable1"
# GraphType = "calibration"
# PercentileBucket = 0.20
# FactLevels = 10
# Function = function(x) mean(x, na.rm = TRUE)
# DateColumn = NULL
# DateAgg_3D = NULL
}
}
\seealso{
Other Model Evaluation and Interpretation: 
\code{\link{AutoShapeShap}()},
\code{\link{CumGainsChart}()},
\code{\link{EvalPlot}()},
\code{\link{ROCPlot}()},
\code{\link{RedYellowGreen}()},
\code{\link{ResidualPlots}()},
\code{\link{SingleRowShapeShap}()},
\code{\link{threshOptim}()}
}
\author{
Adrian Antico
}
\concept{Model Evaluation and Interpretation}
