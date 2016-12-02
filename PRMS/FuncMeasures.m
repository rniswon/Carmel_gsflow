function [Stats,StatsName] = FuncMeasures(QQ,PQQ)
%   -----------------------------------------------------------------------
    Lamda   = 0.3;                              % Value for Lamda transform
%   -----------------------------------------------------------------------    
    QQ      = QQ;                               % Observed values
    LQQ     = log10(QQ);                        % Log10 Transf Obs values
    TQQ     = (1+QQ.^Lamda)/Lamda;              % Lamda Transf Obs values
    cQQ     = cumsum(QQ);                       % Cumsum of Obs values
    cLQQ    = cumsum(LQQ);                      % Cumsum of Log10 Obs values
    sQQ     = sort(QQ);                         % Sorted Observed values
%   -----------------------------------------------------------------------
    PQQ     = PQQ;                              % Predicted values
    LPQQ    = log10(PQQ);                       % Log10 Transf Pred values
    TPQQ    = (1+PQQ.^Lamda)/Lamda;             % Lamda Transf Pred values
    cPQQ    = cumsum(PQQ);                      % Cumsum of Pred values
    cLPQQ   = cumsum(LPQQ);                     % Cumsum of Log10 Pred values
    sPQ     = sort(PQQ);                        % Sorted Predicted values
    
%== COMPUTE STREAMFLOW RESIDUAL STATISTICS ================================
    
%%-- Residual Mean Squared Error Type Statistics --------------------------
    % Residual Mean Squared Error 
        Stats(1)   = var( PQQ-QQ );          
        StatsName(1,:) = ('MSE         ');
    % Residual MSE of Log10 Transformed
        Stats(2)   = var( LPQQ-LQQ );
        StatsName(2,:) = ('MSE Log10   ');
    % Residual MSE of Lamda Transformed
        Stats(3)   = var( TPQQ-TQQ );
        StatsName(3,:) = ('MSE TrLam   ');
    
%%-- Residual Percent Bias Type Statistics --------------------------------    
    % Residual Percent Bias 
        Stats(4)   = 100 * sum( PQQ-QQ ) / sum(QQ);
        StatsName(4,:) = ('PBias       ');
    % Residual Percent Bias of Log10 Transformed
        Stats(5)   = 100 * sum( LPQQ-LQQ ) / sum(LQQ);
        StatsName(5,:) = ('PBias Log10 ');
    % Residual Percent Bias of Lamda Transformed
        Stats(6)   = 100 * sum( TPQQ-TQQ ) / sum(TQQ);
        StatsName(6,:) = ('PBias TrLam ');

%%-- Residual Nash Efficiency Type Statistics -----------------------------
    % Residual Nash Efficiency
        Stats(7)   = 1 - var( PQQ-QQ )/var(QQ);
        StatsName(7,:) = ('NSE         ');
    % Residual Nash Efficiency of Log10 Transformed
        Stats(8)   = 1 - var( LPQQ-LQQ )/var(LQQ);
        StatsName(8,:) = ('NSE Log10   ');
    % Residual Nash Efficiency of Lamda Transformed
        Stats(9)   = 1 - var( TPQQ-TQQ )/var( TQQ );
        StatsName(9,:) = ('NSE TrLam   ');

%%-- Flow Duration Curve Error Statistics ---------------------------------
    % MSE of Flow Duration Curve 
        Stats(10)   = var( sPQ-sQQ );
        StatsName(10,:) = ('MSE FDC     ');
    % MSE of FDC of Log10 Transformed
        Stats(11)   = var( log10(sPQ)-log10(sQQ) );
        StatsName(11,:) = ('MSE FDCLog10');
    % MSE of FDC of Lamda Transformed
        Stats(12)   = var( (sPQ.^Lamda-sQQ.^Lamda) );
        StatsName(12,:) = ('MSE FDCTrLam');

%%-- Other Performance Statistics -----------------------------------------    
    % Correlation between Observed & Simulated
        cc = corrcoef(QQ,PQQ);
        Stats(13)   = 1 - cc(1,2);
        StatsName(13,:) = ('QPCorr      ');
    % MaxAbs Sequential Percent Bias
        Stats(14)   = 100 * max( abs( cPQQ-cQQ )./cQQ );
        StatsName(14,:) = ('MaxAbs PBias');
    % MaxAbs Sequential Percent Bias of Log10
        Stats(15)   = 100 * max( abs( cLPQQ-cLQQ )./cLQQ );
        StatsName(15,:) = ('MaxAbsPBiasL');
    
%%-- Signature Performance Measures ---------------------------------------       
    % Percent Error in Signal Mean
        Stats(16)   = 100 * (mean(PQQ)-mean(QQ)) / mean(QQ);
        StatsName(16,:) = ('Pct Mean Dif');
    % Percent Error in Signal Variance
        Stats(17)   = 100 * (var(PQQ)-var(QQ)) / var(QQ);
        StatsName(17,:) = ('Pct Var Diff');
     % Percent Error in Signal Mean of Log10 Transf
        Stats(18)   = 100 * (mean(LPQQ)-mean(LQQ)) / mean(LQQ);
        StatsName(18,:) = ('Pct L10MeanD');
    % Percent Error in Signal Variance of Log10 Transf
        Stats(19)   = 100 * (var(LPQQ)-var(LQQ)) / var(LQQ);
        StatsName(19,:) = ('Pct L10VarDf');
    % Percent Error in Signal Mean of Lamda Transf
        Stats(20)   = 100 * (mean(TPQQ)-mean(TQQ)) / mean(TQQ);
        StatsName(20,:) = ('Pct LTrMeanD');
    % Percent Error in Signal Variance of Lamda Transf
        Stats(21)   = 100 * (var(TPQQ)-var(TQQ)) / var(TQQ);
        StatsName(21,:) = ('Pct LTrVarDf');
    
% End of function FuncMeasures.m
    
    
    