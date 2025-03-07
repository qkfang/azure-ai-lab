
export async function eventInfo(
  eventCode: string
): Promise<EventInfo> {
  try {
    // const response = await fetch(`/api/${API_VERSION}/eventinfo`, {
    //   method: "POST",
    //   headers: {
    //     accept: "application/json",
    //     "Content-Type": "application/json",
    //     "api-key": eventCode,
    //   },
    //   body: JSON.stringify(eventCode),
    //   signal: abortController.signal,
    // });

    const data = {
      capabilities: {
        "openai-chat": ["gpt-4o"],
        "openai-dalle3": ["dalle-3"]
      },
      event_code: eventCode,
      event_image_url: '',
      max_token_cap: 999999,
      is_authorized: true,
      organizer_name: 'Azure AI Lab',
      organizer_email: '',
    };

    // const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error calling API:", error);
    throw error;
  }
}

export type EventInfo = {
  capabilities: Record<string, string[]>;
  event_code: string;
  event_image_url: string;
  max_token_cap: number;
  is_authorized: boolean;
  organizer_name: string;
  organizer_email: string;
};
