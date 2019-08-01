"use strict";

module.exports = (context, callback) => {
  try {
    const result = JSON.parse(context);
    return callback(undefined, {
      function_status: "success",
      result,
    });

  } catch (error) {
    return callback(undefined, {
      function_status: "error",
      result: `Cannot parse JSON from: ${context}`,
    });

  }
};
