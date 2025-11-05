import json
from typing import AsyncGenerator

from google.adk.agents import Agent, BaseAgent, InvocationContext
from google.adk.agents.events import Event

from story_image_agent.imagen_tool import ImagenTool


class CustomImageAgent(BaseAgent):
  """A custom agent for generating images directly using ImagenTool."""

  def __init__(self, name: str = "custom_image_agent"):
    super().__init__(name=name)
    self.imagen_tool = ImagenTool()

  async def _run_async_impl(
      self,
      ctx: InvocationContext
  ) -> AsyncGenerator[Event, None]:
    """Directly calls ImagenTool to generate an image based on user input."""
    if not ctx.user_content or not ctx.user_content.parts:
      ctx.session.state["image_result"] = {
          "status": "error",
          "message": "No user content provided.",
      }
      yield Event(
          type="result",
          data={"output": "Error: No user content provided."},
      )
      return

    user_message = ctx.user_content.parts[0].text
    scene_description = ""
    character_descriptions = {}

    try:
      # Try to parse the input as JSON
      input_data = json.loads(user_message)
      scene_description = input_data.get("scene_description", "")
      character_descriptions = input_data.get("character_descriptions", {})
    except json.JSONDecodeError:
      # Fallback to plain text if JSON parsing fails
      scene_description = user_message

    # Build the image prompt
    style_prefix = "Children's book cartoon illustration with bright vibrant colors, simple shapes, friendly characters."
    prompt = f"{style_prefix} {scene_description}"

    if character_descriptions:
      character_details = ", ".join(
          f"{name}: {desc}" for name, desc in character_descriptions.items()
      )
      prompt += f" Featuring characters: {character_details}"

    try:
      # Directly execute the ImagenTool
      image_result = await self.imagen_tool.run(prompt=prompt)

      # Store the result in session state
      ctx.session.state["image_result"] = {
          "status": "success",
          "images": image_result,
      }
      yield Event(
          type="result",
          data={"output": json.dumps(ctx.session.state["image_result"])},
      )
    except Exception as e:
      # Handle errors during image generation
      error_message = f"Failed to generate image: {e}"
      ctx.session.state["image_result"] = {
          "status": "error",
          "message": error_message,
      }
      yield Event(type="result", data={"output": error_message})
