MODEL_EX6 = data.frame(target = c(F, F, F, F, T, F, T, T, F, F, F, T, F, T, F, F, T, T, T, T), predicted = c(F, F, F, F, T, F, T, T, F, F, F, T, F ,T , F, F, F, T, T, T));

confusion <- function (model) {
  n = length(model['target'][[1]]);
  output = c(TP = 0, FN = 0, FP = 0, TN = 0, precission = 0, recall = 0, f1 = 0);
  for (index in 1:n) {
    target = model['target'][[1]][index];
    predicted = model['predicted'][[1]][index];
    
    if (target & target == predicted) {
      output['TP'] = output['TP'] + 1;
    }
    
    if (target & target != predicted) {
      output['FN'] = output['FN'] + 1;
    }
    
    if (!target & target == predicted) {
      output['TN'] = output['TN'] + 1;
    }
    
    if (!target & target != predicted) {
      output['FP'] = output['FP'] + 1;
    }
  }
  
  output['precission'] = output['TP'] / (output['TP'] + output['FP']);
  output['recall'] = output['TP'] / (output['TP'] + output['FN']);
  
  output['f1'] = 2 * ((output['precission']*output['recall'])/(output['precission'] + output['recall']));
  
  return (output)
  
}

# Exercise 7

target = c(2623, 2423, 2423, 2448, 2762, 2435, 2519, 2772, 2601, 2422, 2349, 2515, 2548, 2281, 2295, 2570, 2528, 2342, 2456, 2451, 2296, 2405, 2389, 2629, 2584, 2658, 2482, 2471, 2605, 2442);
model1 = c(2664, 2436, 2399, 2447, 2847, 2411, 2516, 2870, 2586, 2414, 2407, 2505, 2581, 2277, 2280, 2577, 2510, 2381, 2452, 2437, 2307, 2355, 2418, 2582, 2564, 2662, 2492, 2478, 2620, 2445);
model2 = c(2691, 2367, 2412, 2440, 2693, 2493, 2598, 2814, 2583, 2485, 2472, 2584, 2604, 2309, 2296, 2612, 2557, 2421, 2393, 2479, 2290, 2490, 2346, 2647, 2546, 2759, 2463, 2403, 2654, 2478);

sse <- function (target, predictions) {
  return (0.5 * sum((target - predictions)^2))
}

total_squares <- function (data) {
  return (   0.5 * sum( (data - mean(data) )^2   )         )
}

rsquared <- function (target, predictions) {
  return ( 1 - (sse(target, predictions) / total_squares(predictions)))
}


model_8_1 = data.frame(
  target = c(F, F, T, T, F, T, T, T, F, F, T, T, T, T, F, T, T, F, F, F, T, T, F, T, F, F,T ,T, F, T),
  predicted = c(0.1026, 0.2937, 0.5120, 0.8645, 0.1987, 0.7600, 0.7519, 0.2994, 0.0552, 0.9231, 0.7563, 0.5664, 0.2872, 0.9326, 0.0651, 0.7165, 0.7677,  0.4468, 0.2176, 0.9800, 0.6562, 0.9693, 0.0275, 0.7047, 0.3711, 0.4440, 0.5440, 0.5713, 0.3757, 0.8224)
);

model_8_1['predicted'] = model_8_1['predicted'] >= 0.5;

model_8_2 = data.frame(
  target = c(F, F, T, T, F, T, T, T, F, F, T, T, T, T, F, T, T, F, F, F, T, T, F, T, F, F,T ,T, F, T),
  predicted = c(0.2089, 0.0080, 0.8378, 0.7160, 0.1891, 0.9398, 0.9800, 0.8578, 0.1560, 0.5600, 0.9062, 0.7301, 0.8764, 0.9274, 0.2992, 0.4569, 0.8086, 0.1458, 0.5809, 0.5783, 0.7843, 0.9521, 0.0377, 0.4708, 0.2846, 0.1100, 0.3562, 0.9200, 0.0895, 0.8614)
)

model_8_2['predicted'] = model_8_2['predicted'] >= 0.5;