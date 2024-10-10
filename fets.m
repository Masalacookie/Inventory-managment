% 定义指数平滑法预测函数
function y_pred_ets = fets(x, h)
    model_ets = fit(ets(x), 'Length', h);
    y_pred_ets = forecast(model_ets, h)';
end
