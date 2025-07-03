"use server"
import { cookies } from "next/headers"

export async function setLanguagePreference(language: "english" | "chichewa") {
  // Set a cookie to remember the user's language preference
  cookies().set("language", language, {
    maxAge: 60 * 60 * 24 * 30, // 30 days
    path: "/",
  })
}

export async function getLanguagePreference(): Promise<"english" | "chichewa"> {
  const language = cookies().get("language")?.value
  return language === "chichewa" ? "chichewa" : "english"
}
