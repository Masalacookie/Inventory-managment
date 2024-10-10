% 定义ARIMA模型预测函数
function y_pred_arima = farima(x, h)
    model_arima = forecast(auto.arima(x), 'h', h);
    y_pred_arima = model_arima.mean';
end