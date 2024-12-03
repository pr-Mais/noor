package com.noor.sa

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.io.InputStream

class HomeScreenSmallWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout_small)
            val bodyText = readJsonFromRaw(context)
            views.setTextViewText(R.id.widget_description, bodyText)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun readJsonFromRaw(context: Context): String {
        return try {
            val inputStream: InputStream = context.resources.openRawResource(R.raw.athkar)
            val jsonText = inputStream.bufferedReader().use { it.readText() }
            parseJson(jsonText)
        } catch (e: Exception) {
            "Error reading JSON"
        }
    }

    private fun parseJson(jsonText: String): String {
        return try {
            val jsonObject = JSONObject(jsonText)
            val athkarArray: JSONArray = jsonObject.getJSONArray("الدعاء إذا تقلب ليلاً")
            val bodyText = StringBuilder()
            for (i in 0 until athkarArray.length()) {
                val athkar = athkarArray.getJSONObject(i)
                bodyText.append(athkar.optString("text", "No text available"))
                bodyText.append("\n\n")
            }
            bodyText.toString().trim()
        } catch (e: Exception) {
            "Error parsing JSON"
        }
    }
}
